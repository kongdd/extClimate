require(zoo)
require(xlsx)
rm(list = ls())
setwd("G:/��������/�½��ɺ�/27��������ָ��Climate_Index_kongdd")
source('Climate_Index.R', encoding = 'GB2312', echo=TRUE)
## �½��ɺ�ϵͳ�����˽�ˮָ��
# fnames <- dir("G:\\��������\\�½��ɺ�\\xinjia1957-2009ziliao", pattern = "5*.xls", full.names = T)
# data <- read.xlsx2(fnames[1], sheetIndex = 1, colClasses = rep("numeric", 8))[, -1]

load("clim.RData")
data <- unique(clim.OriginalData)  #����������ظ���ȥ��
## data <- [year, month, day, Taver, Tmax, Tmin, Precp];����������
#  ����������Ϊ�����������ݣ��������У������п�ֵ
##Segmentʱ��Σ���������Ϊ��"04-10";ˮ������Ϊ��"04-03";������Ϊ"03-05";������Ϊ"04-04",������Ϊ"month"

# ����߶� --------------------------------------------------------------------
clim_data <- dataArange_Before(clim.OriginalData, Segment = "01-12")
clim_dataLs <- split(clim_data, clim_data$labels) ##�����ݰ��ձ��label�зֳɶ�

clim_quantile <- clim.quantile(clim.OriginalData, Period = "1961-1990")    ##���㽵����¶ȵİٷ�λ��
AIndice <-lapply(clim_dataLs, allIndice)                      ##����������dataframe
AIndice <- do.call(rbind.data.frame, AIndice)                   
head(AIndice)
write.xlsx2(AIndice, file = "����ָ��.xlsx")
# file.show("����ָ��.xlsx")
# # ���³߶� --------------------------------------------------------------------
# 
# clim_data <- dataArange_Before(data, Segment = "month")
# clim_dataLs <- split(clim_data, clim_data$labels) ##�����ݰ��ձ��label�зֳɶ�
# 
# clim_quantile <- clim.quantile(data, Period = "1961-1990")    ##���㽵����¶ȵİٷ�λ��
# AIndice <-lapply(clim_dataLs, allIndice)                      ##����������dataframe
# AIndice <- do.call(rbind.data.frame, AIndice)                   
# head(AIndice)