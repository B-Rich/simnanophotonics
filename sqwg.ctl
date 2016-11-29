; This code calculate some basic properties of a square waveguide using a dipole source.
; It is initially modified from an example from http://isblokken.dk/wiki/doku.php/note/201210_3d_waveguide_model .
; By Xiaodong Qi (i2000s@hotmail.com), 2016-11-28.

; Materials
(define SiO2 (make dielectric (index 1.46)))
(define Vac (make dielectric (index 1.0)))
(define SiN (make dielectric (index 1.98)))

; Waveguide
(define-param mwg SiN) ; waveguide material
(define-param wwg 0.3) ; waveguide width. Nanometer is the unit for length.
(define-param hwg 0.3) ; waveguide height
(define-param lwg 5) ; initial waveguide length


; Cladding
(define-param mcl Vac) ; cladding material
;	(define-param mcl SiO2) ; cladding material

; Light
(define-param lwavelength 0.895) ; light pulse center wavelength (frequency)
(define-param ldf 2.0e-8)  ; light pulse width [in frequency]. Unit freq is 3e14 in Hz.

; Paddings and pmls
(define-param tpml 1) ; thickness of PML
(define-param xpad 2) ; thickness of x-padding
(define-param ypad 2) ; thickness of y-padding
(define-param zpad 0) ; thickness of z-padding


; Resolution
(define-param res 20) ; resolution of computational cell

; Default material
(set! default-material mcl)

; Run with sub-pixel averaging?
(set! eps-averaging? false)

; Calculation of parameters
(define xsz (+ wwg (* 2 xpad) (* 2 tpml)) ) ; x-size of computational cell
(define ysz (+ hwg (* 2 ypad) (* 2 tpml)) ) ; y-size of computational cell
(define zsz (+ lwg (* 2 zpad) (* 2 tpml)) ) ; z-size of computational cell

; SET COMPUTATIONAL CELL SIZE
(set! geometry-lattice
		(make lattice (size xsz ysz zsz))
)

; MAKE GEOMETRY

(set! geometry
	(list
		; Build WG and extend it thru PMLs and PADs
		(make block (center 0 0 0) (size wwg hwg zsz) (material mwg))
	)
)


; SET PMLs
(set! pml-layers (list (make pml (thickness tpml))))

; SET RESOLUTION
(set-param! resolution res)

; SET SOURCES
(set! sources
		(list
            (make source
		       		  (src (make continuous-src (wavelength lwavelength) (fwidth ldf) (end-time 200) ))
					          (component Ex) (size 0 0 0) (center (+ (/ wwg 2) 0.2) 0 0)

			      )
		 )
)

(run-until 60
	(at-beginning output-epsilon)
	(at-every 10 output-efield-x)
	(at-every 10 output-efield-y)
	(at-every 10 output-efield-z)
)
