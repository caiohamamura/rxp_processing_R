#!/usr/bin/env Rscript
# devtools::install_github("caiohamamura/r_hancock_bin_reader")
args = commandArgs(trailingOnly=TRUE)

#install.packages("pacman")

pacman::p_load(
  HancockBinReader,
  data.table,
  lidR,
  TreeLS
)

folder = "R:/bin_clouds/p120/"
files = dir(folder, pattern = "*day1_loc1_*", full.names = T)
file = files[1]

zmin = Inf
zmax = -Inf

for (file in files) {
  data = HancockBinReader::read_hancock_bin(file)
  
  z_offset = data$offsets[3,1]
  all_beams = data.table(data$beams)
  all_returns = data.table(data$returns)
  rm(data)
  
  setkey(all_beams, shot_n)
  setkey(all_returns, shot_n)
  xyz = all_returns[
    all_beams[,list(shot_n, zen, z),],
    list(
      z=cos(zen*pi/180)*r+z
    ), 
    nomatch=0]
  rangeZ = range(xyz)+z_offset
  
  if (rangeZ[2] > zmax) zmax = rangeZ[2]
  if (rangeZ[1] < zmin) zmin = rangeZ[1]
}

print(zmin)
print(zmax)
