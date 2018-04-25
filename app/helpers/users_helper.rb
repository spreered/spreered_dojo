module UsersHelper

  def rect_avatar(avatar)
    content_tag :div, class: 'imgbox' do
      content_tag :div, class: 'imgbox-inner' do
        content_tag :div, class: 'imgbox-fit' do
          image_tag avatar
        end
      end
    end
  end
end
