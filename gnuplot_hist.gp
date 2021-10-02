binwidth=0.1
bin(x,width)=width*floor(x/width)
plot 'distribucion.dat' using (bin($1,binwidth)):(1.0) smooth freq with boxes
