class HomesController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  
  def index
    @news = News.all.order("created_at DESC")
    @fake_news = FakeNews.all.order("created_at DESC")
  end
  
  def fake_news
    @fake_news = FakeNews.new
    @fake_news.title = params[:title]
    @fake_news.user_ip = request.remote_ip
    @fake_news.thumb_nail = params[:image]
    @fake_news.save
    redirect_to "/"
  end
  
  def index_json
    @news = News.all
    render json: @news
  end
  
  def news_search
    @option = params[:option]
    
    if (@option == "1")
      @news_result = News.where("title like ?", "%#{params[:search_text]}%").order("created_at DESC")
    end
    
    else if (@option == "2")
      @news_result = FakeNews.where("title like ?", "%#{params[:search_text]}%").order("created_at DESC")
    end
  end
end
