# 参考URL:https://qiita.com/Sota_N/items/dfd435c4ebee29e100f7

install.packages('twitteR')

library(twitteR)

# TwitterAPIのKeyとTokenを読み込ませる
consumerKey <- '5Csdd2iaISW1bg2oeZxpoTMvh'
consumerSecret <- 'LAH3U4SqXPF2V8iP41IzjE6wLDkkxhXng0pqWSWt8Ih2XpEDwn'
accessToken <- '959308856-exfnSMqXHpHCJABpuRAn8goNwvfljDzErwNVtt3V'
accessTokenSecret <- 'KKtX4BwuPCtB3nxQBVJpMoK0quSjLcsbCUtq6mWjnRbmE'

# setup_twitter_oauth()関数の引数に先程のKeyとToken（の変数）を渡して、適当な変数に代入
cred <- setup_twitter_oauth(
  consumer_key = consumerKey,
  consumer_secret = consumerSecret,
  access_token = accessToken,
  access_secret = accessTokenSecret
)

# ツイートを取得
# アカウント名は＠は不要 クォーテーションでくくる
tweets_sukego <- userTimeline('sukego_fut', 500)
tweets_raikaruto <- userTimeline('qwertyuiiopasd', 500)
tweets_yuuki <- userTimeline('yuukikouhei', 500)
tweets_tonton <- userTimeline('sabaku1132', 500)

# 各ツイートをデータフレーム型に変換
TwGetDF_sukego <- twListToDF(tweets_sukego)
TwGetDF_raikaruto <- twListToDF(tweets_raikaruto)
TwGetDF_yuuki <- twListToDF(tweets_yuuki)
TwGetDF_tonton <- twListToDF(tweets_tonton)

# 結合
tweets_football <- rbind(TwGetDF_sukego, TwGetDF_raikaruto, TwGetDF_yuuki, TwGetDF_tonton)
# テキストデータとして書き出す
write.table(tweets_football, 'tweets_football.txt')

# 形態素解析
install.packages('RMeCab')
library(RMeCab)
# パイプ演算子使用のため
library(dplyr)

# RMeCabFreq()関数 : ファイルから頻度表を作成
# RMeCabFreq()関数によって単語への分かち書き、品詞情報、頻度を得ることが可能
Freq_tweets_football <- RMeCabFreq('tweets_football.txt')

# Freq列から頻度が3より大きく500未満のもの
# Info1列から品詞が名詞のもの、Info2列から数以外のものを抽出
Filter_Freq_tweets_football <- Freq_tweets_football %>% 
  filter(Freq>10&Freq<500, Info1%in% c("名詞"), Info2 != "数")

# wordcloudパッケージを呼び出し
library(wordcloud)

# wordcloudの描画
wordcloud(Filter_Freq_tweets_football$Term, Filter_Freq_tweets_football$Freq, random.order=FALSE,
          color=rainbow(5),random.color=FALSE,scale=c(2,1),min.freq=10)

# グラフ描画
library(ggplot2)

ggplot(data = Filter_Freq_tweets_football) +
  geom_bar(aes(Term, Freq), stat = 'identity')+
  theme_classic() +
  theme(axis.text.x = element_text(size = 7, angle = 90, hjust = 1))
