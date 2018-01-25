Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'site#index'

  get 'index' => 'site#index'
  get 'about' => 'site#about'
  get 'news' => 'articles#index'
  get 'case' => 'articles#case'
  get 'report' => 'sites#new'
  post 'report' => 'sites#create'

  get 'article/article_type/:type_id' => 'articles#type'
  get 'category/:alias' => 'articles#type_alias'
  get 'article/:alias' => 'articles#alias'
  get 'site/:alias' => 'sites#alias'
  get 'page/:alias' => 'page#show'

  get 'search_result' => 'site#search_result'
  get 'search_articles' => 'site#ajax_search_articles'
  get 'search_sites' => 'site#ajax_search_sites'

  post 'func/sms_send' => 'site#sms_send'
  post 'func/sms_send_reg' => 'site#sms_send_reg'
  post 'func/sms_send_admin' => 'site#sms_send_admin'
  post 'func/upload_image' => 'site#upload_image'
  post 'func/upload_avatar' => 'site#upload_avatar'
  post 'func/post_comments' => 'comments#ajax_comments'
  post 'func/update_user' => 'users#ajax_update'
  post 'func/update_pwd' => 'users#ajax_update_password'
  post 'func/update_pwd_out' => 'users#ajax_update_password_out'
  post 'func/register' => 'users#ajax_register'
  post 'func/login' => 'users#ajax_login'
  post 'func/commit_site' => 'sites#ajax_create'

  get 'login' => 'users#login'
  post 'users/login' => 'users#postlogin'
  get 'register' => 'users#register'
  post 'users/register' => 'users#postregister'
  get 'changepassword' => 'users#changepassword_out'

  get 'users/logout' => 'users#logout'

  get 'users/usercenter' => 'users#usercenter'
  get 'users/userinfo' => 'users#userinfo'
  get 'users/comments' => 'users#comments'
  get 'users/messages' => 'users#messages'
  get 'users/changepassword' => 'users#changepassword'
  get 'users/changephone' => 'users#changephone'

  resources :site
  resources :sites
  resources :articles
  resources :comments
  resources :messages

  mount RuCaptcha::Engine => '/rucaptcha'
  captcha_route

  namespace :admin do
    # Directs /admin/products/* to Admin::ProductsController
    # (app/controllers/admin/products_controller.rb)
    root 'site#index'

    get 'index' => 'site#index'
    get 'dashboard' => 'site#dashboard'
    get 'login' => 'site#login'
    post 'login' => 'site#login_post'

    get 'member' => 'manager#member'
    get 'member-edit' => 'manager#member_edit'
    post 'member-edit' => 'manager#member_edit_post'

    get 'send-meaasge' => 'manager#send_message'
    post 'send-meaasge' => 'manager#send_message_post'

    get 'site-new' => 'manager#site_new'
    post 'site-new' => 'manager#site_new_post'
    get 'site-list' => 'manager#site_list'
    get 'site-edit' => 'manager#site_edit'
    post 'site-edit' => 'manager#site_edit_post'
    get 'site-pass' => 'manager#site_pass'
    get 'site-delete' => 'manager#site_delete'

    get 'article-new' => 'manager#article_new'
    post 'article-new' => 'manager#article_new_post'
    get 'article-list' => 'manager#article_list'
    get 'article-edit' => 'manager#article_edit'
    post 'article-edit' => 'manager#article_edit_post'
    get 'article-delete' => 'manager#article_delete'

    get 'article-colum-manage' => 'manager#article_colum_manage'
    post 'article-colum-manage' => 'manager#article_colum_add'
    get 'article-colum-edit' => 'manager#article_colum_edit'
    post 'article-colum-edit' => 'manager#article_colum_edit_post'
    get 'article-colum-delete' => 'manager#article_colum_delete'

    get 'commet-list' => 'manager#commet_list'
    get 'commet-delete' => 'manager#commet_delete'

    get 'site-setting' => 'manager#site_setting'
    post 'site-setting' => 'manager#site_setting_post'

    get 'menu-edit' => 'manager#menu_edit'
    post 'menu-edit' => 'manager#menu_edit_post'
    get 'menu-item-edit' => 'manager#menu_item_edit'
    post 'menu-item-edit' => 'manager#menu_item_edit_post'
    get 'menu-item-delete' => 'manager#menu_item_delete'

    get 'page-new' => 'manager#page_new'
    post 'page-new' => 'manager#page_new_post'
    get 'page-edit' => 'manager#page_edit'
    post 'page-edit' => 'manager#page_edit_post'
    get 'page-list' => 'manager#page_list'
    get 'page-delete' => 'manager#page_delete'
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
