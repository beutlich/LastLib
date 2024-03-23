set title 'Minimum Plot'
set xlabel 'time [s]'
set ylabel 'state [-]'
set style line 1 lc rgb '#0060ad' lw 1 pi -1 ps 1.0
set style line 2 lc rgb '#dd181f' lw 1 pi -1 ps 1.0
plot 'data.txt' using 1:3 smooth unique with line ls 1 title 'original signal', 'data.txt' smooth unique with line ls 2 title 'minimum signal'
