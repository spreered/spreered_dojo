module PostsHelper
  def collect_btn(post)
    if post.is_collected?(current_user)
      link_to 'uncollect', uncollect_post_path(post), method: :post,remote: true, class:'btn btn-outline-primary mr-1 align-self-center uncollect-btn'
    else
      link_to 'collect', collect_post_path(post), method: :post, remote: true, class:'btn btn-outline-primary mr-1 align-self-center collect-btn'
 
    end
  end
end
