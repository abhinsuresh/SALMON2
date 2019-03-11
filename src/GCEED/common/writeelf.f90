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
!======================================================================
!======================================================================
subroutine writeelf(lg)
  use structures, only: s_rgrid
  use writefile3d
  use scf_data
  use allocate_mat_sub
  implicit none
  type(s_rgrid),intent(in) :: lg
  character(30) :: suffix
  character(30) :: phys_quantity
  character(10) :: filenum
  character(20) :: header_unit

  if(iSCFRT==1)then 
    suffix = "elf"
  else if(iSCFRT==2)then
    write(filenum, '(i6.6)') itt
    suffix = "elf_"//adjustl(filenum)
  end if
  phys_quantity = "elf"
  if(format3d=='avs')then
    header_unit = "none"
    call writeavs(103,suffix,header_unit,elf)
  else if(format3d=='cube')then
    call writecube(lg,103,suffix,phys_quantity,elf,hgs,igc_is,igc_ie,gridcoo)
  else if(format3d=='vtk')then
    call writevtk(lg,103,suffix,elf,hgs,igc_is,igc_ie,gridcoo)
  end if
  
end subroutine writeelf

