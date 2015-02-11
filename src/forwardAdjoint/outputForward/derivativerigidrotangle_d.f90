!        generated by tapenade     (inria, tropics team)
!  tapenade 3.10 (r5363) -  9 sep 2014 09:53
!
!  differentiation of derivativerigidrotangle in forward (tangent) mode (with options i4 dr8 r8):
!   variations   of useful results: derivativerigidrotangle
!   with respect to varying inputs: timeref
!
!      ******************************************************************
!      *                                                                *
!      * file:          derivativerigidrotangle.f90                     *
!      * author:        edwin van der weide                             *
!      * starting date: 06-01-2004                                      *
!      * last modified: 06-12-2005                                      *
!      *                                                                *
!      ******************************************************************
!
function derivativerigidrotangle_d(degreepolrot, coefpolrot, &
& degreefourrot, omegafourrot, coscoeffourrot, sincoeffourrot, t, &
& derivativerigidrotangle)
!
!      ******************************************************************
!      *                                                                *
!      * derivativerigidrotangle computes the time derivative of the    *
!      * rigid body rotation angle at the given time for the given      *
!      * arguments. the angle is described by a combination of a        *
!      * polynomial and fourier series.                                 *
!      *                                                                *
!      ******************************************************************
!
  use flowvarrefstate
  use inputphysics
  implicit none
!
!      function type
!
  real(kind=realtype) :: derivativerigidrotangle
  real(kind=realtype) :: derivativerigidrotangle_d
!
!      function arguments.
!
  integer(kind=inttype), intent(in) :: degreepolrot
  integer(kind=inttype), intent(in) :: degreefourrot
  real(kind=realtype), intent(in) :: omegafourrot, t
  real(kind=realtype), dimension(0:*), intent(in) :: coefpolrot
  real(kind=realtype), dimension(0:*), intent(in) :: coscoeffourrot
  real(kind=realtype), dimension(*), intent(in) :: sincoeffourrot
!
!      local variables.
!
  integer(kind=inttype) :: nn
  real(kind=realtype) :: dphi, val
  intrinsic sin
  intrinsic cos
  integer :: pwy1
  real(kind=realtype) :: pwr1
!
!      ******************************************************************
!      *                                                                *
!      * begin execution                                                *
!      *                                                                *
!      ******************************************************************
!
! return immediately if this is a steady computation.
  if (equationmode .eq. steady) then
    derivativerigidrotangle = zero
    derivativerigidrotangle_d = 0.0_8
    return
  else
! compute the polynomial contribution.
    dphi = zero
    do nn=1,degreepolrot
      pwy1 = nn - 1
      pwr1 = t**pwy1
      dphi = dphi + nn*coefpolrot(nn)*pwr1
    end do
! compute the fourier contribution.
    do nn=1,degreefourrot
      val = nn*omegafourrot
      dphi = dphi - val*coscoeffourrot(nn)*sin(val*t)
      dphi = dphi + val*sincoeffourrot(nn)*cos(val*t)
    end do
! set derivativerigidrotangle to dphi. multiply by timeref
! to obtain the correct non-dimensional value.
    derivativerigidrotangle_d = dphi*timerefd
    derivativerigidrotangle = timeref*dphi
  end if
end function derivativerigidrotangle_d
