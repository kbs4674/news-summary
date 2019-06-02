var newson = true;
var newsout = {};
var i = 0;

function getUrl(url) {
    var URLContent = "";
    var bufferedReader = new java.io.BufferedReader(new java.io.InputStreamReader(java.net.URL(url).openStream()));

    var temp = "";
        while ((temp = bufferedReader.readLine()) != null) {
        URLContent +=(temp + "\n");
        }
        bufferedReader.close();
    return URLContent;
}

function response(room, msg, sender, isGroupChat, replier) {
if(msg.indexOf("eval") == 0 && sender=="김철민" || sender=="이동현") {
    replier.reply(eval(msg.substring(5)));
}
if(msg.indexOf("이말이안들어갈때") == -1 && newson == true && msg != "eval newson = true") {
    var newsstring = getUrl("https://news-bot-kr.herokuapp.com/homes/index_json").replace("[{","").replace("}]","").replace(/{/g,"\n\n").replace(/":"/g," : ").replace(/":/g," : ");
    newsstring = newsstring.replace(/id/g,"번호").replace(/title/g,"제목").replace(/content/g, "컨텐츠").replace(/category/g,"카테고리").replace(/null/g,"없음").replace(/thumb_nail/g,"링크").replace(/news_url/g,"원본뉴스").replace(/created_at/g,"올린시간").replace(/updated_at/g,"쓴시간").replace(/"/g, "");
    newsstring = newsstring.split(',');
    for(var i in newsstring) {
        newsout += newsstring[i] + "\n";
    }
    replier.reply(newsout.replace("[object Object]","").replace(/"/g,""));
    newson = false;
    java.lang.Thread({
    run : function(){
    java.lang.Thread.sleep(60000);
    newson = true;}})
    }
}