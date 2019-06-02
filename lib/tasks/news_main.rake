## rake "news_main:news_main"

namespace :news_main do
  require 'nokogiri'
  require 'open-uri'
  require 'mechanize'
  
  task news_main: :environment do
    
    News.all.each do |x|
      if Time.now - x.created_at >= 2.days
        x.destroy
      end
    end

    doc = Nokogiri::HTML(open("https://news.naver.com/"))
    @news_url = doc.css('div#today_main_news > div.hdline_news > ul.hdline_article_list > li > div.hdline_article_tit > a').map { |link| link['href'] }
    
    @news_title_array = Array.new
    @news_content_array = Array.new
    @news_thumb_nail_array = Array.new
    
    ## 뉴스기사 내용 크롤링
    for i in 0..@news_url.length-1
      docs = Nokogiri::HTML(open("https://news.naver.com#{@news_url[i]}"))
      @news_title = docs.css('div.article_info > h3#articleTitle').map { |cur| cur.text.strip }
      @news_content = docs.css('div.article_body > #articleBodyContents').map { |cur| cur.text.strip.gsub("// flash 오류를 우회하기 위한 함수 추가\nfunction _flash_removeCallback() {}\n\n\t\n\t", "").gsub("동영상 뉴스\n\t\t\n\t\n\n\n\n", "") }
      @news_thumb_nail = docs.css('span.end_photo_org > img').map { |link| link['src'] }
      
      @news_title_array.push(@news_title)
      @news_content_array.push(@news_content)
      @news_thumb_nail_array.push(@news_thumb_nail)
    end

    ## 3줄요약
    @news_summary_entitle = Array.new
    news_summary = Mechanize.new
    summary_page = news_summary.get("https://summariz3.herokuapp.com")
    summary = summary_page.form_with(:action => "/")
    for i in 0..@news_url.length-1
      summary.field_with(:name => "content").value = "#{@news_content_array[i].map(&:inspect).join('').gsub('\\', "")}"
      login_result_newbie = news_summary.submit summary
      @summary_crawling = Nokogiri::XML(login_result_newbie.body.force_encoding("UTF-8")).css('li').map { |cur| cur.text.strip.gsub("[", "") }
      News.create(title: "#{@news_title_array[i].map(&:inspect).join('\n').gsub("[", "").gsub('"', "").gsub('"', "").gsub("]", "").gsub('\\', '"')}", category: "Today Main", content: "#{@summary_crawling[0]}<br/>#{@summary_crawling[1]}<br/>#{@summary_crawling[2]}", thumb_nail: "#{@news_thumb_nail_array[i][0].gsub("[", "").gsub('"', "").gsub('"', "").gsub("]", "")}", news_url: "https://news.naver.com#{@news_url[i]}")
      sleep 12;
    end
    
  end
end