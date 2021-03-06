# make figure 1 from paper
options(stringsAsFactors=FALSE)
library(ggplot2)
args = commandArgs(TRUE)


df = read.delim(args[1])

df[df$method == "bis2", "method"] = "bismark-bt2"
df[df$method == "bis1", "method"] = "bismark-bt1"
df[df$method == "bwastrand", "method"] = "bwa-strand"
df[df$method == "bwa", "method"] = "bwameth"

df[grep("sim_R1", df$method, fixed=TRUE), "method"] = "bison"
df[grep("real_R1", df$method, fixed=TRUE), "method"] = "bison"

points = c('bismark-bt1', 'bismark-bt2', 'gsnap')
df$size = as.numeric(ifelse(df$method %in% points, 1.2, 0.4))


df = df[df$qual > 0,]

df = df[order(df$qual),]

df = df[(df$on + df$off) != 0,]
df$on = df$on * 100
df$off = df$off * 100

require("grid")


p = ggplot(df, aes(x=off, y=on, by=method)) +
         geom_point(aes(shape=method, size=size, linestyle=method)) +
         scale_size_identity() +
         scale_shape(solid = FALSE) +
         guides(size=FALSE, linestyle=FALSE) +
         geom_line(data=df[!df$method %in% points,], aes(shape=method), size=0.4) +
         scale_shape(solid = FALSE) +
         guides(linestyle=FALSE) 


         #geom_line(aes(linestyle=method), size=1.4) + scale_shape(solid=FALSE)
         #geom_line(aes(color=method), linetype="dotted") 
p = p + ylab("% Reads On Target")
p = p + xlab("% Reads Off Target")
p = p + theme_bw()
p = p + theme(
             #legend.position = c(0.55, 0.25),
             legend.position = c(0.75, 0.25),
              legend.text=element_text(size=6, lineheight=5),
              axis.text=element_text(size=6),
              axis.title=element_text(size=8),
              legend.key.size=unit(6, "mm")

#              legend.key.height=5
              )
p = p + guides(shape=guide_legend(ncol=2, title=NULL), size=FALSE, method=FALSE)
ggsave(file=args[2], units="cm", width=8.6, height=6.3,
    dpi=400)
