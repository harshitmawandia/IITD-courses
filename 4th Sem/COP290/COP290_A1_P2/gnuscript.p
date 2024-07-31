set terminal png
set output "mkltiming.png"
plot "mkltiming.txt" using 1:2:3:xticlabels(4) w boxerror lc rgb "#444333" lw 2 title "MKL Time"
set term eps
set output "mkltiming.eps"
replot
set terminal png
set output "openblastiming.png"
plot "openblastiming.txt" using 1:2:3:xticlabels(4) w boxerror lc rgb "#444333" lw 2 title "Openblas Time"
set term eps
set output "openblastiming.eps"
replot
set terminal png
set output "pthreadtiming.png"
plot "pthreadtime.txt" using 1:2:3:xticlabels(4) w boxerror lc rgb "#444333" lw 2 title "pThread Time"
set term eps
set output "pthreadstiming.eps"
replot
