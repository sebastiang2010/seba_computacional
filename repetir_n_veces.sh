start=1
end=1000
clear 
#for i in {$start..$niter} #no funciona 
 
for (( i=$start; i<=$end; i++ )) #como c++
do
    ./ejecutable_ising_4
    echo "  "
    cp -v Magnetizacion.dat  Magnetizacion$i.dat  
    cp -v output.dat  output$i.dat  
    echo " " 
    echo "Nunero" $i "/" $end #no me sale como variable    
    echo " " 
done
