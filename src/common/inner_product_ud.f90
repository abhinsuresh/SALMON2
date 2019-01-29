!
!  Copyright 2017 SALMON developers
!
!  Licensed under the Apache License, Version 2.0 (the "License");
!  you may not use this file except in compliance with the License.
!  You may obtain a copy of the License at
!
!      http://www.apache.org/licenses/LICENSE-2.0
!
!  Unless required by applicable law or agreed to in writing, software
!  distributed under the License is distributed on an "AS IS" BASIS,
!  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!  See the License for the specific language governing permissions and
!  limitations under the License.
!
module inner_product_ud_sub

  implicit none
  
  interface inner_product_ud
  
    module procedure r_inner_product_ud, c_inner_product_ud
  
  end interface
  
  contains

!=======================================================================
  subroutine r_inner_product_ud(mg,matbox1,matbox2,rbox2,iwk_size)
    use structures, only: s_rgrid
    use salmon_parallel, only: nproc_group_korbital, nproc_group_h
    use salmon_communication, only: comm_summation
    implicit none
    type(s_rgrid),intent(in) :: mg
    real(8),intent(in) :: matbox1(mg%is(1):mg%ie(1),mg%is(2):mg%ie(2),mg%is(3):mg%ie(3))
    real(8),intent(in) :: matbox2(mg%is(1):mg%ie(1),mg%is(2):mg%ie(2),mg%is(3):mg%ie(3))
    real(8),intent(out) :: rbox2
    integer,intent(in) :: iwk_size
    integer :: ix,iy,iz
    real(8) :: rbox
    
    rbox=0.d0
    !$omp parallel do reduction(+ : rbox) private(iz,iy,ix)
    do iz=mg%is(3),mg%ie(3)
    do iy=mg%is(2),mg%ie(2)
    do ix=mg%is(1),mg%ie(1)
      rbox=rbox+matbox1(ix,iy,iz)*matbox2(ix,iy,iz)
    end do
    end do
    end do
    
    if(iwk_size>=1.and.iwk_size<=2)then
      call comm_summation(rbox,rbox2,nproc_group_korbital)
    else if(iwk_size>=11.and.iwk_size<=12)then
      call comm_summation(rbox,rbox2,nproc_group_h)
    else
      write(*,*) "iwk_size is not set" 
      stop
    end if
  
  end subroutine r_inner_product_ud
  
!=======================================================================
  subroutine c_inner_product_ud(mg,matbox1,matbox2,cbox2,iwk_size)
    use structures, only: s_rgrid
    use salmon_parallel, only: nproc_group_korbital, nproc_group_h
    use salmon_communication, only: comm_summation
    implicit none
    type(s_rgrid),intent(in) :: mg
    complex(8),intent(in)  :: matbox1(mg%is(1):mg%ie(1),mg%is(2):mg%ie(2),mg%is(3):mg%ie(3))
    complex(8),intent(in)  :: matbox2(mg%is(1):mg%ie(1),mg%is(2):mg%ie(2),mg%is(3):mg%ie(3))
    complex(8),intent(out) :: cbox2
    integer,intent(in) :: iwk_size
    integer :: ix,iy,iz
    complex(8) :: cbox
    
    cbox=0.d0
    !$omp parallel do reduction(+ : cbox) private(iz,iy,ix) 
    do iz=mg%is(3),mg%ie(3)
    do iy=mg%is(2),mg%ie(2)
    do ix=mg%is(1),mg%ie(1)
      cbox=cbox+conjg(matbox1(ix,iy,iz))*matbox2(ix,iy,iz)
    end do
    end do
    end do
    
    if(iwk_size>=1.and.iwk_size<=2)then
      call comm_summation(cbox,cbox2,nproc_group_korbital)
    else if(iwk_size>=11.and.iwk_size<=12)then
      call comm_summation(cbox,cbox2,nproc_group_h)
    else
      write(*,*) "iwk_size is not set" 
      stop
    end if
    
  end subroutine c_inner_product_ud
  
end module inner_product_ud_sub

