!        generated by tapenade     (inria, tropics team)
!  tapenade 3.10 (r5363) -  9 sep 2014 09:53
!
!  differentiation of computeeddyviscosity in reverse (adjoint) mode (with options i4 dr8 r8 noisize):
!   gradient     of useful results: *rev *w *rlv
!   with respect to varying inputs: *w *rlv
!   plus diff mem management of: rev:in w:in rlv:in
!
!      ******************************************************************
!      *                                                                *
!      * file:          computeeddyviscosity.f90                        *
!      * author:        georgi kalitzin, edwin van der weide            *
!      * starting date: 03-10-2003                                      *
!      * last modified: 06-12-2005                                      *
!      *                                                                *
!      ******************************************************************
!
subroutine computeeddyviscosity_b()
!
!      ******************************************************************
!      *                                                                *
!      * computeeddyviscosity computes the eddy viscosity in the        *
!      * owned cell centers of the given block. it is assumed that the  *
!      * pointes already point to the correct block before entering     *
!      * this subroutine.                                               *
!      *                                                                *
!      ******************************************************************
!
  use flowvarrefstate
  use inputphysics
  use iteration
  use blockpointers
  implicit none
!
!      local variables.
!
  logical :: returnimmediately
!
!      ******************************************************************
!      *                                                                *
!      * begin execution                                                *
!      *                                                                *
!      ******************************************************************
!
! check if an immediate return can be made.
  if (eddymodel) then
    if (currentlevel .le. groundlevel .or. turbcoupled) then
      returnimmediately = .false.
    else
      returnimmediately = .true.
    end if
  else
    returnimmediately = .true.
  end if
  if (.not.returnimmediately) then
! determine the turbulence model and call the appropriate
! routine to compute the eddy viscosity.
    select case  (turbmodel) 
    case (spalartallmaras, spalartallmarasedwards) 
      call saeddyviscosity_b()
    end select
  end if
end subroutine computeeddyviscosity_b
