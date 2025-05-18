class ArticlesController < ApplicationController
  def index
    @article = Article.all.sample
  end
end
