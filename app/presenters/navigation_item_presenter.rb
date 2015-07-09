class NavigationItemPresenter
  def initialize(text, link, active = false)
    @text = text
    @link = link
    @active = active
  end

  def to_s
    if @active
      "<p class='blog__navigation__item'>#{@text}</p>".html_safe
    else
      "<p class='blog__navigation__item'>#{helpers.link_to(@text, @link)}</p>".html_safe
    end
  end

  private

  def helpers
    ActionController::Base.helpers
  end
end
