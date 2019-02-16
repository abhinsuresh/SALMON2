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
subroutine calc_iroot(iob,iroot,ilsda,nproc_ob,iparaway_ob,itotmst,mst)
  use calc_iquotient_sub
  implicit none
  integer,intent(in)  :: iob
  integer,intent(out) :: iroot
  integer,intent(in)  :: ilsda,nproc_ob,iparaway_ob,itotmst,mst(2)
  
  if(ilsda==0)then
    if(iparaway_ob==1)then
      call calc_iquotient(iob,nproc_ob,itotmst,iroot)
    else if(iparaway_ob==2)then
      iroot=mod(iob-1,nproc_ob)
    end if
  else
    if(iparaway_ob==1)then
      if(iob<=mst(1))then
        call calc_iquotient(iob,nproc_ob,mst(1),iroot)
      else
        call calc_iquotient(iob-mst(1),nproc_ob,mst(2),iroot)
      end if
    else if(iparaway_ob==2)then
      if(iob<=mst(1))then
        iroot=mod(iob-1,nproc_ob)
      else
        iroot=mod(iob-1-mst(1),nproc_ob)
      end if
    end if 
  end if

end subroutine calc_iroot
