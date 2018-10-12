## ����ʱ��߶�ETCCDI����ָ��
## Writed By kongdd, 2015/06/05
## Sun Yat-Sen University, Guangzhou, China
## email: kongdd@mail2.sysu.edu.cn
## ������ʹ��climdex.pcic�Ѿ���֤������T quantile�йص��ĸ�TN10p,TX10p,TN90p,TX90p��������ȫһ��
## ========================================================================
## �������ĸ���ָ��
## �ο����ף�
#         [1] ����, ��ǿ, �Ž���, ��. 1961-2010 ���½����˽�ˮ����ʱ������[J]. �����о�, 2014, 10: 010.
#         [2] Bartholy J, Pongr��cz R. Regional analysis of extreme temperature and precipitation indices for the Carpathian basin
#             from 1946 to 2001. Global and Planetary Change, 2007, 57(1-2): 83-95.
#         [3] http://etccdi.pacificclimate.org/list_27_indices.shtml
# =========================================================================
# �����¶ȵ�16��ָ�� --------------------------------------------------------------
## 1 FD,  Number of frost days: Annual count of days when TN (daily minimum temperature) < 0
## 2 SU,  Number of summer days: Annual count of days when TX (daily maximum temperature) > 25
## 3 ID,  Number of icing days: Annual count of days when TX (daily maximum temperature) < 0
## 4 TR,  Number of tropical nights: Annual count of days when TN (daily minimum temperature) > 20
## 5 GSL, Growing season length: Annual (1st Jan to 31st Dec in Northern Hemisphere (NH), 1st July to 30th 
#         June in Southern Hemisphere (SH)) count between first span of at least 6 days with daily mean 
#         temperature TG>5oC and first span after July 1st (Jan 1st in SH) of 6 days with TG<5oC. 
#         1-6�µĵ�һ����������6��ƽ�����¸��ڶ����¶���7-12�µ�һ����������6��ƽ�����¸��ڶ����¶ȵĳ�������
#  6-9 �¼���������¡���������¼���ֵ����������¼�Сֵ���¼����������
#   TXx,  Monthly maximum value of daily maximum temperature
#   TNx,  Monthly maximum value of daily minimum temperature
#   TXn,  Monthly minimum value of daily maximum temperature
#   TNn,  Monthly minimum value of daily minimum temperature
#  10-13  TN10p, Percentage of days when TN < 10th percentile
#         TX10p, Percentage of days when TX < 10th percentile
#         TN90p, Percentage of days when TN > 90th percentile
#         TX90p, Percentage of days when TX > 90th percentile
#  14 WSDI, Warm speel duration index: Annual count of days with at least 6 consecutive days when TX > 90th percentile
#  15 CSDI, Cold speel duration index: Annual count of days with at least 6 consecutive days when TN < 10th percentile
#  16 DTR, Daily temperature range: Monthly mean difference between TX and TN
# ���ڽ�ˮ��11��ָ�� --------------------------------------------------------------
#  17.Rx1day  1 �ս�ˮ�����ֵ
#  18.Rx5day  ����5 �ս�ˮ�����ֵ
#  19 SDII    �ս�ˮ��֮�����ս�ˮ���� 1 mm������֮��
#  20-22.RRn  ����������n mm������
#  23.CDD     �����ս�ˮ����������1 mm���������ֵ
#  24.CWD     �����ս�ˮ���������ڵ���1 mm���������ֵ
#  25-26      �������95%��99%�ٷ�λֵ��Ӧ���������ۼƽ�������
#             R95D     �����ս�ˮ�����ڱ�׼ʱ���ս�ˮ�����е�95 �ٷ�λֵ������֮��
#             R99D     �����ս�ˮ�����ڱ�׼ʱ���ս�ˮ�����е�99 �ٷ�λֵ������֮��
#             R95P    �����ս�ˮ�����ڱ�׼ʱ���ս�ˮ�����е�95 �ٷ�λֵ�Ľ�ˮ��֮��
#             R99P    �����ս�ˮ�����ڱ�׼ʱ���ս�ˮ�����е�99 �ٷ�λֵ�Ľ�ˮ��֮��
#  27.PRCPTOT �ս�ˮ���� 1 mm�Ľ�ˮ��֮��
## ========================================================================

daysOfMonth <- function(year, month){
  days <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  day <- days[month]
  if((year %% 4 == 0 && year %% 100 != 0 || year %% 400 ==0) && month ==2) day <- 29
  day ## return quickly
}
## ���ݸ�ʽ����
dataArange_Before <- function(data, Segment = "04-03"){
##data <- [year, month, day, Taver, Tmax, Tmin, Precp];����������
##Segmentʱ��Σ���������Ϊ��"04-10";ˮ������Ϊ��"04-03";������Ϊ"03-05";������Ϊ"04-04",������Ϊ"month"
  # data <- unique(data)  #����������ظ���ȥ��
  date_string <- sprintf("%d-%d-%d", data[, 1], data[, 2], data[, 3])
  date_daily <- as.Date(date_string)
  n <- nrow(data)
  ## by year, season,  hydrologic year(generally this.year04 - next.year03)
  # ������������һ��ʼ���ݽ�ȡ��
  if (Segment == "month"){
    beginMonth <- data[1, 2]
    endMonth <- data[n, 2]
    ## �����������ڵ�����������޳�
    id_begin <- 1; id_end <- n
    if (data[1, 3] != 1)
      id_begin <- which(date_daily == as.Date(sprintf("%d-%d-%d", data[1, 1], beginMonth, daysOfMonth(data[1,1], beginMonth)))) + 1
    ## ���ݲ�����year-12-31����
    if (data[n, 3] != daysOfMonth(data[n, 1], endMonth)) 
      id_end <- which(date_daily == as.Date(sprintf("%d-%d-%d", data[n, 1], endMonth, 1))) - 1
    if (length(id_end) == 0 | length(id_begin) == 0 | (id_begin == id_end)) warning("���ݳ��ȹ��̣�������Ҫһ���£�\n")
    data <- data[id_begin:id_end, ]##�س�����Ҫ�Ĳ���
    date_daily <- date_daily[id_begin:id_end]
    data_trim <- cbind(data, labels = format(date_daily, "%Y-%m"))
  }else{
    ## ����ˮ����,�������ݸ�ʽ��Segment <- "04-10"
    beginMonth <- as.numeric(substr(Segment, 1, 2))
    endMonth <- as.numeric(substr(Segment, 4, 5))
    ## �����������ڵ�����������޳�
    if (!(data[1, 2] == beginMonth & data[1, 3] == 1)) 
      id_begin <- which(date_daily == as.Date(sprintf("%d-%d-01", data[1, 1] + 1, beginMonth)))
    ## ���ݲ�����year-12-31����
    if (!(data[n, 2] == endMonth & data[n, 3] == daysOfMonth(data[n, 1], endMonth))) 
      id_end <- which(date_daily == as.Date(sprintf("%d-%d-%d", data[n, 1] - 1, endMonth, daysOfMonth(data[n, 1] - 1, endMonth))))
    if (length(id_end) == 0 | length(id_begin) == 0) warning("���ݳ��ȹ��̣�������Ҫһ���꣡\n")
    
    data <- data[c(id_begin:id_end), ]##�س�����Ҫ�Ĳ���
    #  ���ݷֶα�Ǵ��������aggregateʹ��
    if ((endMonth - beginMonth == 11) | (beginMonth - endMonth == 1)){
      Years <- data[, 1]; Months <- data[, 2]
      ##example:ʱ���"04-03", ��2014.01-03���Ϊ2013�꣬2014.04-2015.03���Ϊ2014��
      label_func <- function(i) {
        if (Months[i] < beginMonth)
          label = Years[i] - 1
        else
          label = Years[i]
        label##return quickly
      }
      labels <- sapply(1:length(Years), label_func)
      data_trim <- cbind(data, labels)
    }else{
      ##���beginMonth <= endMonth,��ʱ���"04-010"�� InMonth = 4:10;elseʱ���"04-02"�� InMonth = c(4:12, 1:2); 
      if (beginMonth <= endMonth) InMonth <- beginMonth:endMonth else InMonth <- c(beginMonth:12, 1:endMonth)
      
      Id <- which(as.numeric(data[, 2]) %in% InMonth)
      
      Nind <- length(Id)
      indTag <- numeric(Nind) + data[1, 1] ##������ݱ��
      nEvent <- data[1, 1]                 ##��ʼ��
      
      for (i in 1:(Nind-1)){
        if (Id[i + 1] != Id[i] + 1) nEvent <- nEvent+1
        indTag[i+1] <- nEvent
      }
      data_trim <- cbind(data[Id, ], labels = indTag)
    }
  }
  clim.data <- data.frame(SpecialValue(data_trim), labels = data_trim$labels)
  # colnames(clim.data) <- c("year", "month", "day", "precp", "Taver", "Tmax", "Tmin", "labels")
  clim.data##quickly return,clim.data
}

# ���ꡢ�¶ȡ�����ֵ��Ǵ��� -----------------------------------------------------------

SpecialValue <- function(X){
  ## ��ȡ��Ӧ��������
  Precp <- X[, 7]
  Tem_aver <- X[, 4]
  Tem_max <- X[, 5]
  Tem_min <- X[, 6]
  
  # ����ֵ��Ǵ���----------------------------------------------------------------- ��ˮ
  Precp[Precp == 32766] = NA
  Precp[Precp == 32700] = 1
  Precp[which(Precp >= 32000)] <- Precp[which(Precp >= 32000)] - 32000  #����¶˪
  Precp[which(Precp >= 31000)] <- Precp[which(Precp >= 31000)] - 31000  #���ѩ������
  Precp[which(Precp >= 30000)] <- Precp[which(Precp >= 30000)] - 30000  #ѩ��(���������ѩ��ѩ����
  Precp <- Precp/10  #origin 0.1mm
  ## �¶�
  Tem_max[Tem_max == 32766] = NA
  Tem_min[Tem_min == 32766] = NA
  Tem_max <- Tem_max/10
  Tem_min <- Tem_min/10
  Tem_aver[Tem_aver == 32766] = NA
  Tem_aver <- Tem_aver/10
  
  Xnew <- data.frame(X[, 1:3], Tem_aver, Tem_max, Tem_min, Precp)
  colnames(Xnew) <- c("year", "month", "day", "Taver", "Tmax", "Tmin", "precp");Xnew##quickly return
}

# temperature and Precipitation quantile values ---------------------------

clim.quantile <- function(X, Period = "1961-1990"){
  data <- SpecialValue(X)
  date_string <- sprintf("%d-%d-%d", data[, 1], data[, 2], data[, 3])
  date_daily <- as.Date(date_string)
  data <- zoo(data, date_daily)
  BeginYear <- as.numeric(substr(Period, 1, 4)); EndYear <- as.numeric(substr(Period, 6, 9))
  ## ��ȡ��׼���������λ��ֵ
  standardPeriod <- seq(as.Date(sprintf("%d-01-01", BeginYear)), as.Date(sprintf("%d-12-31", EndYear)), by = "day")
  data_trim <- window(data, standardPeriod)
  if (length(data_trim) == 0){
    warning("��ѡ��ı�׼���ڲ��������ݣ�")
    return()
  }
  ## �����¶� the calendar day 90th percentile centred on a 5-day window for the base period
  filterSmooth <- function(x, width = 5){
    x <- as.numeric(x);n <- length(x)
    X_temp <- cbind(x[1:(n - width + 1)], x[2:(n - width + 2)], x[3:(n - width + 3)], x[4:(n - width + 4)], x[5:(n - width + 5)])
    apply(X_temp, 1, mean, na.rm = T)
  }
  
  Tmax.filter <- filterSmooth(data_trim[, 5])
  Tmin.filter <- filterSmooth(data_trim[, 6])
  
  ## 95th percentile of precipitation on wet days in the period
  Precp <- data_trim[, 7]; Precp_trim <- Precp[Precp >= 1.0]
  result <- c(quantile(Tmax.filter, c(0.1, 0.9)), quantile(Tmin.filter, c(0.1, 0.9)), quantile(Precp_trim, c(0.95, 0.99)))
  names(result) <- c("Tmax.10th", "Tmax.90th", "Tmin.10th", "Tmin.90th", "RR.95th", "RR.99th")
  result##quantile result quickly return
}

## �������б��
ContinueTag <- function(X){
  Nind <- length(X)
  if (Nind == 0) return(0) #��������������ɺ���ʪ���򷵻ؿ�ֵ
  if (Nind == 1) return(1)  #�������һ��ɺ���ʪ��
  
  Tag <- numeric(Nind)   #��ǵڼ�����������
  nEvent = 1;Tag[1] <- 1 #�ڼ�����������
  
  for (i in 1:(Nind-1)){
    if (X[i+1]!=X[i]+1) nEvent<-nEvent+1
    Tag[i+1] <- nEvent
  }
  Tag##quickly return
}

# �����¶ȵ�16��ָ�� --------------------------------------------------------------
## 1 FD, number of frost days: Annual count of days when TN (daily minimum temperature) < 0
clim.FD <- function(Tmin) length(which(Tmin < 0))##for Tmin
## 2 SU, Number of summer days: Annual count of days when TX (daily maximum temperature) > 25
clim.SU <- function(Tmax) length(which(Tmax > 25))##for Tmin
## 3 ID,  Number of icing days: Annual count of days when TX (daily maximum temperature) < 0
clim.ID <- function(Tmax) length(which(Tmax < 0))##for Tmin
## 4 TR,   Number of tropical nights: Annual count of days when TN (daily minimum temperature) > 20
clim.TR <- function(Tmin) length(which(Tmin > 20))##for Tmin

## 5 Growing season length: Annual (1st Jan to 31st Dec in Northern Hemisphere (NH), 1st July to 30th 
#  June in Southern Hemisphere (SH)) count between first span of at least 6 days with daily mean 
#  temperature TG>5oC and first span after July 1st (Jan 1st in SH) of 6 days with TG<5oC. 
#  1-6�µĵ�һ����������6��ƽ�����¸��ڶ����¶���7-12�µ�һ����������6��ƽ�����¸��ڶ����¶ȵĳ�������
#  ������ָ��Ҫ������Ϊ���꣬������Ĳ����Զ���ȥ
#  δ��¼����������ʼʱ�䣬������Ҫcall me
clim.GSL <- function(Taver){
  if (length(Taver) < 365) {
    warning("����������ֻ�ܰ�����߶�")
    return(NA)
  }
  Nmid <- floor(length(Taver)/2); N <- length(Taver)
  ## �ٶ�������Taver�������������룬����������ʼʱ����1:(n/2)�Σ���������[(n/2)+1]:n�Σ�n��ʾ���ݳ���
  Id_begin <- which(Taver > 5)
  Tag <- ContinueTag(Id_begin)
  segment.length <- sapply(1:Tag[length(Tag)], function(i) length(which(Tag == i)))
  TagId <- which(segment.length >= 6)[1]            ##������Ҳ����򷵻ؿ�ֵ
  point.begin <- Id_begin[which(Tag == TagId)[1]]   ##��������ʼ����Ҫ��7��֮ǰ,���δ���ҵ���Ϊ��ֵ����ֵ����
  
  Id_end <- which(Taver[(Nmid+1):N] < 5) + Nmid
  Tag <- ContinueTag(Id_end)
  segment.length <- sapply(1:Tag[length(Tag)], function(i) length(which(Tag == i)))
  TagId <- which(segment.length >= 6); TagId <- TagId[1]            ##������Ҳ����򷵻ؿ�ֵ
  point.end <- Id_end[which(Tag == TagId)]; point.end <- point.end[1]##��������ʼ����Ҫ��7��֮ǰ,���δ���ҵ���Ϊ��ֵ����ֵ����
  if ((length(point.begin)==0) | (length(point.end)==0 ))  return(NA)##���ݹ���
  if (is.na(point.begin) | is.na(point.end))  return(NA)##���ݹ���.;
  
  if (point.begin >= 183) point.begin <- NA
  if (point.end < 183) end.point <- NA
  if (is.na(point.begin) | is.na(point.end)) warning("����������ʼʱ�䲻�ڹ涨��Χ�ڣ���˶����ݣ�")
  point.end - point.begin##return gsl,�����ʼ�㲻��1-6�£������㲻��7-12���򷵻ؿ�ֵ
}

## 6-9 �¼���������¡���������¼���ֵ����������¼�Сֵ���¼����������
#     TXx, Monthly maximum value of daily maximum temperature
#     TNx, Monthly maximum value of daily minimum temperature
#     TXn, Monthly minimum value of daily maximum temperature
#     TNn, Monthly minimum value of daily minimum temperature
clim.TXx <- function(Tmax) max(Tmax, na.rm = T)
clim.TNx <- function(Tmin) max(Tmin, na.rm = T)
clim.TXn <- function(Tmax) min(Tmax, na.rm = T)
clim.TNn <- function(Tmin) min(Tmin, na.rm = T)
##   10-13 TN10p, Percentage of days when TN < 10th percentile
#       TX10p, Percentage of days when TX < 10th percentile
#       TN90p, Percentage of days when TN > 90th percentile
#       TX90p, Percentage of days when TX > 90th percentile
clim.Tthp <- function(Tmax, Tmin, Tquantile = clim_quantile){
  N <- length(Tmax) ##Tmax, Tmin�����豣��һ��
  TN10p <- length(which(Tmin < Tquantile["Tmin.10th"]))/N
  TX10p <- length(which(Tmax < Tquantile["Tmax.10th"]))/N
  TN90p <- length(which(Tmin > Tquantile["Tmin.90th"]))/N
  TX90p <- length(which(Tmax > Tquantile["Tmax.90th"]))/N
  data.frame(TN10p, TX10p, TN90p, TX90p)
} 
## 14 WSDI, Warm speel duration index: Annual count of days with at least 6 consecutive days when TX > 90th percentile
clim.WSDI <- function(Tmax, Tquantile = clim_quantile){
  Id <- which(Tmax > Tquantile["Tmax.90th"])
  Tag <- ContinueTag(Id)
  segment.length <- sapply(1:Tag[length(Tag)], function(i) length(which(Tag == i)))
  sum(segment.length[which(segment.length >= 6)])
}
## 15 CSDI, Cold speel duration index: Annual count of days with at least 6 consecutive days when TN < 10th percentile
clim.CSDI <- function(Tmin, Tquantile = clim_quantile){
  Id <- which(Tmin < Tquantile["Tmin.10th"])
  Tag <- ContinueTag(Id)
  segment.length <- sapply(1:Tag[length(Tag)], function(i) length(which(Tag == i)))
  sum(segment.length[which(segment.length >= 6)])
}
## 16 DTR, Daily temperature range: Monthly mean difference between TX and TN
clim.DTR <- function(Tmax, Tmin){
  N <- length(Tmax) ##Tmax, Tmin�����豣��һ��
  sum(Tmax - Tmin, na.rm = T)/N ##ƽ�������սϲ�
}
# ���ڽ�ˮ��11��ָ�� --------------------------------------------------------------
##  17-18 n�ս�ˮ�����ֵ
clim.RX <- function(precp){
  precp <- as.matrix(precp); Ndays <- length(precp)
  data_R5 <- cbind(precp[1:(Ndays-4)], precp[2:(Ndays-3)],precp[3:(Ndays-2)],precp[4:(Ndays-1)],precp[5:(Ndays)])#������󻬶����
  Rx5 <- max(apply(data_R5, 1, sum, na.rm=T))
  Rx1 <- max(precp)
  data.frame(Rx1 = Rx1, Rx5 = Rx5)#quickly return
}

# 19SDII    �ս�ˮ��֮�����ս�ˮ���� 1 mm������֮��
clim.SDII <- function(precp) sum(precp[which(precp >= 1)])/length(which(precp >= 1))

## 20-22����������n mm������
clim.RRN <- function(precp, nm = c(10, 20, 25)){
  rrn <- sapply(nm, function(x) length(which(precp >= x)))
  rrn <- data.frame(t(rrn))
  colnames(rrn) <- paste("RR", nm, sep = "");rrn
}

## 23-24���������ɺ�������ʪ������
clim.CDD <- function(precp, item = "drought"){
  if (!item %in% c("drought", "wet")) stop("item param must bu 'drought' or 'wet'!")
  if(item == "drought") cdd.id <- which(precp < 1) else cdd.id <- which(precp >= 1)
  
  Tag <- ContinueTag(cdd.id)
  cdd <- max(sapply(1:Tag[length(Tag)],function(i) length(which(Tag == i)))) ##���������ɺ�����
  cdd##quickly return
}

## 25-26�������95%��99%�ٷ�λֵ��Ӧ���������ۼƽ�������
clim.Rquantile <- function(precp, quantile.standard){
  R_days <- sapply(1:2, function(i) length(which(precp > quantile.standard[i])))#list1 for q95, list2 for q99, days
  R_precp <- sapply(1:2, function(i) sum(precp[which(precp > quantile.standard[i])]))#list1 for q95, list2 for q99, calculate
  data.frame(R95D = R_days[1], R99D = R_days[2], R95P = R_precp[1], R99p = R_precp[2])##quickly return 
}
# 27PRCPTOT �ս�ˮ���� 1 mm�Ľ�ˮ��֮��
clim.PRCPTOT <- function(precp) sum(precp[which(precp >= 1)])


# �ۺ� ----------------------------------------------------------------------

# �����¶ȵ�16��ָ�� --------------------------------------------------------
TIndice <- function(X, Quantile = clim_quantile){ ##�������м��˽�ˮָ��
  Tmin <- X$Tmin; Tmax <- X$Tmax; Taver <- X$Taver; precp <- X$precp
  FD <- clim.FD(Tmin)
  SU <- clim.SU(Tmax)
  ID <- clim.ID(Tmax)
  TR <- clim.TR(Tmin)
  GSL <- clim.GSL(Taver)
  TXx <- clim.TXx(Tmax)
  TNx <- clim.TNx(Tmin)
  TXn <- clim.TXn(Tmax)
  TNn <- clim.TNn(Tmin)
  Tthp <- clim.Tthp(Tmax, Tmin, Quantile)
  WSDI <- clim.WSDI(Tmax, Quantile)
  CSDI <- clim.CSDI(Tmin, Quantile)
  DTR <- clim.DTR(Tmax, Tmin)
  cbind(FD, SU, ID, TR, GSL, TXx, TNx, TXn, TNn, Tthp, WSDI, CSDI, DTR)##quickly return 13 extreme precp indice
}
# ���ڽ�ˮ��11��ָ�� ----------------------------------------------------------
precpIndice <- function(X, Quantile = clim_quantile){ ##�������м��˽�ˮָ��
  precp <- X$precp
  Rx <- clim.RX(precp)
  SDII <- clim.SDII(precp)
  RRN <- clim.RRN(precp, nm = c(10, 20, 25))
  CDD <- clim.CDD(precp, item = "drought")
  CWD <- clim.CDD(precp, item = "wet")
  Rquantile <- clim.Rquantile(precp, Quantile[c("RR.95th", "RR.99th")])
  PRCPTOT <- clim.PRCPTOT(precp)
  data.frame(Rx, SDII, RRN, CDD, CWD, Rquantile, PRCPTOT)##quickly return 13 extreme precp indice
}
allIndice <- function(X, Quantile = clim_quantile) data.frame(TIndice(X, Quantile), precpIndice(X, Quantile))
Clim.Indice <- function(X, quantile = clim_quantile, index = "all"){
  ## index���룺�������1.all indice, 2.��c("FD", "SU", ), 
  index <- c("FD", "SU", "ID", "TR", "GSL", "TXx","TNx", "TXn", "TNn", "Tthp", "WSDI", "CSDI") 
}