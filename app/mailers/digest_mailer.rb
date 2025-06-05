class DigestMailer < ApplicationMailer
  default from: "byteMail101@gmail.com"

  def daily_chapter(user)
    @user = user
    @article = Article.order("RANDOM()").first
    return if @article.nil?

    mail(
      to: @user.email,
      subject: "Your Daily Rails Guide: #{@article.title}"
    )
  end
end
