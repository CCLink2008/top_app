module ApplicationHelper
  # 根据title 设置每页的标题信息
  def full_title(page_title='')
 	base_title = "Ruby on Rails Tutorial Sample App"
 	if page_title.empty?
 		base_title 
 	else
 		"#{page_title}|#{base_title}"
 	end 
  end
end
