program issing_1
	use ziggurat
	implicit none
	
	logical :: es
	integer :: seed, i, j, nissing, niter,nmatriz, n, f,c,M,cont_no_cambia
	!logical :: parar
	real:: suma,x, dE, beta, KT,p,E
	real, parameter:: Jota=0.35, Ho=0, T=1, K=1
	real (kind=8), allocatable :: S(:,:), Magnetizacion(:),Emedia(:)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11
!! Revisar formulas 
!! Agregar un contador para todos los casos 
!! Agregar el espejo 
!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	 
![NO TOCAR] Inicializa generador de número random

	inquire(file='seed.dat',exist=es)
	if(es) then
		open(unit=10,file='seed.dat',status='old')
		read(10,*) seed
		close(10)
		print *,"  * Leyendo semilla de archivo seed.dat"
	else
		seed = 24583490
	end if

	call zigset(seed)
![FIN NO TOCAR]    

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11
!!! inicializo 

nissing=20 
nmatriz=50!! esto esta por ahora para no repetir la filas y columas 
niter=20000

KT=K*T

!!!!!
!!! alocate 
allocate(S(nmatriz,nmatriz), Magnetizacion(niter),Emedia(niter))
!!!!!!!

!!!!!!!!!! 
!!! abro los archivos 
!open(1, file = 'input.dat',status='old')
!open(2, file = 'output.dat',status='old')
!open(3, file = 'distribucion.dat', status='old') 
!open(4, file=  'histograma.dat', status='old')
open(5, file= 'Magnetizacion.dat',status='old')
open(16, file= 'S.dat',status='old')
!!!!!!!!!

!read(1,*) n
!close(1)

!!!!!!!!!!!!!!!!!
!!! Modelo de Ising 

!! ver como es la mejor forma de ordenar 
do i=1,nmatriz 
  do j=1,nmatriz 
   x=uni()
   if (x<=0.5) then 
   x=1
   else 
   x=-1
   end if
   S(i,j)=x 
   write(16,*) "S(",i,",",j,"):", x 
   !print *, "i: ", i , "j: ", j, x
end do 
end do 
close(16)

cont_no_cambia=0

!print *, " " 
!print *, "Selecciono las filas y columas"

!write(5,*) "# n , Magnetizacion(n), Emedia(n)"
do n=1,niter
   !do i=1,nissing
     ! do j=1,nissing 
        f=nint(uni()*nissing)+1  !init redondea 
        c=nint(uni()*nissing)+1
        !print *," "
        !print *, " Eleccion, fila: ", f, "columna :",c
        !! calculo el delta E 
        dE=-Jota*S(f,c)*(S(f+1,c)+S(f,c+1)+S(f-1,c)+S(f,c-1))-Ho*S(f,c) 
        dE=2*Jota*S(f,c)*(S(f+1,c)+S(f,c+1)+S(f-1,c)+S(f,c-1))-Ho*S(f,c) !! sacado de matlab
        !print *, "fila: ", f , "columna: ", c 
        !print *, "Delta E : ", dE  
        !! Algoritmo de Markov 
        if (dE<=0)then !! agregar como un and
          !print *, "delta E <0, cambio de estado"
          !! cambio el estado 
          S(f,c)=-S(f,c)
        else 
        !! Boltzmann probability of flipping
        !! prob = exp(-dE / kT);
          p=exp(-dE/KT)
          if (p<uni()) then !! no entiendo bien esta parte por que un estado del sistema
          !print *, "Se p<uni(), cambio de estado"
          S(f,c)=-S(f,c)
          else 
          !print *, "No se cambia el spin"
          cont_no_cambia=cont_no_cambia+1
          end if
        end if  
   !end do 
  !end do 
  !!
  M=0
  E=0
  
  do f=1,nissing 
    do c=1,nissing 

    M=M+S(f,c)
    E=S(f,c)*(S(f+1,c)+S(f,c+1)+S(f-1,c)+S(f,c-1))-Ho*S(f,c)
     
    end do 
  end do 
  Magnetizacion(n)=dble(M)/dble((nissing)**2)
  Emedia(n)=dble(n)/dble((nissing)**2)
  write(5,fmt="(i5,x,3f10.4,x,3f10.4)") n , Magnetizacion(n), Emedia(n) 

end do 



print *, " "
print *, "No cambia:", cont_no_cambia
print *, "Cambia:", niter-cont_no_cambia
print *, " "
print *, " Fin del programa"


close(5)



!! 
!! FIN FIN edicion
!! 
![No TOCAR]
! Escribir la última semilla para continuar con la cadena de numeros aleatorios 

		open(unit=10,file='seed.dat',status='unknown')
		seed = shr3() 
		write(10,*) seed
		close(10)
![FIN no Tocar]        

end program issing_1
