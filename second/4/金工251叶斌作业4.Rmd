library(data.table)
#1. 包的简介：data.table是⼀个什么包，⼀般⽤来做什么？和第三次作业中最后⼀题所讲到的那个数据结构有什么区别和联系？可以⽤什么函数将那个数据结构与data.table格式进⾏转换？请利⽤mtcars这个数据集进⾏实际操作。
#答:data.table 是 R 语言中一款 高性能的数据处理包,用途是高效数据操作. #所有数据框能做的操作,data.table 都能直接支持,但data.table速度快、语法简洁、内存效率高。 
#as.data.table()或setDT()将数据框转换成data.table as.data.frame将data.table转换成数据框。 
a1 <- as.data.table(mtcars) 
class(a1)#[1] "data.table" "data.frame"

#2. 数据的导入和导出问题：data.table⽤以读取外部数据的函数是哪⼀个？可以⽤来读取什么格式的数据？将data.table格式保存到外部的函数是哪⼀个？请利⽤mtcars这个数据集进⾏实际操作。 
#答:导入外部数据fread() 导出外部数据fwrit() 可以读取CSV、TSV等，最常用的是 CSV/TSV/ 文本文件。实际操作失败。

#3.基本语法：data.table的基本语法[i, j, by]当中，i、j、by分别表⽰什么含义？他们都分别可以进⾏什么操作？三者同时存在时运⾏的顺序是什么？请利⽤mtcars这个数据集进⾏实际操作。 
#答:i行筛选，j列操作 ，by分组变量 
#先 i → 再 by → 最后 j 
b1 <- as.data.table(mtcars) 
# 行筛选 
c1 <- b1[mpg > 20] # 选择mpg>20的行 
# 列操作 
c2 <- b1[, .(mpg, hp)] # 选择mpg和hp两列 
# 分组操作 
c3 <- b1[, .(avg_hp = mean(hp)), by = cyl] # 按cyl分组计算hp平均值 

#4. 变量引⽤：如果要在data.table中要对某个变量进⾏操作，如何引⽤这个变量？请利⽤mtcars这个数据集，对其中任意两个变量进⾏引⽤，并对⼆者做加法，给出代码。 
#答：1.符号引用;2.$符号引用.
a2 <- as.data.table(mtcars)
a2 <- data.table(a = 1:3, b = 4:6)
a2[, .(a + b)]#返回结果：5, 7, 9
a2$a + a2$b#返回结果：5, 7, 9

#5. 数据筛选I：data.table中如何进⾏⾏筛选？进⾏⾏筛选⼀般需要在i中给定的数据格式是什么（精确到向量的基本格式）？如何进⾏列筛选？data.frame格式的列筛选的语法如何？data.frame当中的列筛选⽅式能不能⽤在data.table当中？请利⽤mtcars这个数据集进⾏实际操作。 
#答：行筛选：在[i]中使用逻辑向量。 
#列筛选：在[j]中使用 .() 选择多列并保持 data.table 结构。 
#data.frame 的列筛选方法（如 df[, c("col1", "col2")]）在data.table中基本可用。 
b1[mpg > 20 & cyl %in% c(4, 6)]#筛选 mpg > 20 且 cyl 为 4 或 6 的行 
b1[, .(mpg, cyl, hp)]# 选择指定列 
b1[, c("cyl")]#data.frame 中列筛选

#6. 数据筛选II：data.table当中，如果要将数据表中的某个变量（某列） 进⾏选取，最终选择出来的这⼀列变量还是⼀个data.table，应该⽤什么⽅式？最终如果选择出这⼀列变量，并⽣成⼀个向量，应该⽤哪种⽅式（只⽤⼀⾏操作）？请利⽤mtcars这个数据集进⾏实际操作。 
#答：最终选择出来的这⼀列变量还是⼀个data.table，应使用.()语法。选择出这⼀列变量，并⽣成⼀个向量，应该使用 $ 符号。 
b1[,.(cyl)]#保持 data.table 格式 
b1$cyl#生成向量格式

#7排序：data.table中，同时根据多个变量进⾏排序怎么做？如何进⾏升序和降序排列？在基本语法[i,j, by]三个部分当中哪些部分可以直接进⾏排序操作？在i中操作可不可以同时进⾏筛选和排序操作？请利⽤mtcars这个数据集进⾏实例操作。 
#答：data.table中的排序操作可以通过order()函数实现，支持多变量排序和升序/降序排列。在[i, j, by]语法中，排序操作主要在i部分进行，可以通过order()函数实现多变量排序。同时，在i部分可以同时进行筛选和排序操作。 
b1[order(cyl, vs, -mpg)]#按三个变量排序：cyl升序、vs升序、mpg降序. 
b1[mpg > 20][order(-hp)]# 筛选mpg\>20后按hp降序排列

#8. 添加或更改列数据：data.table当中，添加或更改⼀列数据，需要⽤到什么函数？如果需要同时添加多列数据需要怎么做（请在⼀⾏代码中实现）？请利⽤mtcars这个数据集进⾏实际操作，添加或更改任意列的数据。 
#答：在 data.table 中添加或更改列数据主要使用 := 赋值操作符,通过 list() 函数可以在单行代码中同时添加多个新列. 
b1[, mpg := mpg * 2]# 修改现有列，将 mpg 列的值乘二 。
b1[, c("sum_col", "hp_ratio") := list(mpg + cyl, hp / 10)]#添加两列mpg+cyl、hp/10。

#9. 分组I：什么是分组操作？by与keyby有什么区别？data.table中如何进⾏依据多个变量进⾏分组后的组内求和操作？请请利⽤mtcars这个数据集，并结合上⼀题的⽅式，进⾏该操作⽰例。 
#答：按照一个或多个 “分组变量”将整个数据集分割成若干个相互独立的小组， 
#by返回的结果在分组变量上是无序的，keyby返回的结果会根据分组变量自动进行升序排序。 
b1[, .(and = sum(mpg, hp)), by = .(mpg, hp)]#按mpg和hp两个变量分组，然后对两列求和，结果命名为and.

#10. 分组II：在by中如何将分组和筛选进⾏组合操作？请请利⽤mtcars这个数据集，并结合上⼀题的⽅式，进⾏操作⽰例。 
#答：在 data.table 中，将分组和筛选进行组合操作是一个常见且强大的功能，主要通过 [i, j, by] 语法结构中的 i 部分实现筛选，by 部分实现分组。 
b1[mpg > 20, mpg/2, by = .(mpg,hp)]#筛选mpg>20后mpg/2,然后按mpg和hp两个变量分组。

#11. 特殊函数I：.SD在data.table中表⽰什么？使⽤后会⽣成⼀个什么数据结构？经过分组操作以后⽣成的结构是怎样的？请利⽤mtcars这个数据集进⾏实例操作。 
#答：.SD 是 data.table 中的一个特殊内置变量,不进行分组时生成整个原始 data.table 进行分组时生成前这个分组的数据子集 
d1 <- b1[, lapply(.SD, mean), by = cyl, .SDcols = c("mpg", "hp")]#按cyl分组，计算mpg和hp的平均值

#12. 特殊函数II：.N在data.table当中表⽰什么？使⽤后会⽣成⼀个什么数据结构？经过分组操作以后⽣成的结构是怎样的？请利⽤mtcars这个数据集进⾏实例操作。 
#答：.N 是 data.table 中的一个特殊内置变量代表了当前分组下的行数,不进行分组时代表整个 data.table 的总行数,进行分组时代表该组的行数 
e1<- b1[, .(count = .N), by = cyl]# 按cyl分组，计算每个分组的观测值数量

#13. 特殊函数III：data.table当中的chaining是⼀种什么操作？⼀般⽤在什么时候？如果我想针对mtcars中的数据先筛选出vs和am都为1的观测，然后再分别计算另外两个变量mpg和cyl的平均值，并⽣成mpg_aver和cyl_aver两个变量，请利⽤chaining的⽅式给出代码。 
#答：Chaining是将多个 data.table 操作串联执行的方法,适用于执行多步数据处理流程,避免创建大量临时变量 
f1 <- b1[vs == 1 & am == 1, .(mpg_a = mean(mpg), cyl_a = mean(cyl))]# 筛选+计算平均值

#14. join操作（横向合并）：如果两张表存在两个相同的共同变量，要进⾏join的合并操作，需要⽤到什么语法？有哪两种操作⽅式？两种操作⽅式存在什么区别？ 
#在 data.table 中，当两张表存在两个相同的共同变量时，合并操作主要通过 on 参数实现。 
#有内连接和左连接两种方式，内连接仅保留匹配行,左连接保留 b1 全部行。

#15. bind操作（竖向合并）：如果两张表要进⾏bind操作并需要⽤到什么函数（请⼀定使⽤data.table当中的函数）？请把mtcars数据集当中的所有数据都+1，⽣成另⼀个数据集，并于原来的数据集进⾏合并。 
b11 <- copy(b1) 
b11[, lapply(.SD, `+`, 1)]# 生成新数据集（所有值+1） 
h1 <- rbindlist(list(b1, b11))# 使用rbindlist进行垂直合并

#16. melt与cast操作：什么是melt与cast操作？请利⽤mtcars这个数据集进⾏针对任意变量的melt与cast实际操作。 
#答：melt操作将一个宽格式的数据表转换为长格式 ，cast操作将一个长格式的数据表转换为宽格式。 
i1 <- melt(b1, id.vars = "cyl", measure.vars = c("mpg", "hp"))#melt操作：宽数据转长数据 
j1 <- dcast(i1, cyl ~ variable, mean)#cast操作：长数据转宽数据
