# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

SiteType.create(title: '全部')
SiteType.create(title: '传销')
SiteType.create(title: '赌博')
SiteType.create(title: '诈骗')
ArticleType.create(title: '电信诈骗')
ArticleType.create(title: '传销窝点')
Permission.create(level: 99, title: '超级管理员')
Permission.create(level: 89, title: '管理员')
Permission.create(level: 1, title: '用户')
Permission.create(level: 0, title: '游客')
# User.create(username: 'admin',
#             password_digest: 'e10adc3949ba59abbe56e057f20f883e',
#             nickname: '管理员',
#             phone: '10086',
#             avatar: '/img/default-avatar.jpg',
#             permission_id:99)
Link.create(url:'/report.html',
            title:'举报中心',
            sort:1)
Link.create(url:'/news.html',
            title:'安全资讯',
            sort:1)
Link.create(url:'/case.html',
            title:'真实案例',
            sort:1)
Link.create(url:'/about.html',
            title:'关于',
            sort:1)
#
#
# Article.create(title:'中国大陆居民半年接到47亿个境外诈骗电话,经济损失近百亿元',
#                content:'尽管我国在打击电信诈骗犯罪方面取得了一些成效，但面对日益严峻的犯罪形势，打击治理工作还面临诸多问题和困难，难以从根本上遏制此类犯罪发展蔓延的势头。 据了解，侦破难度大，打击效果差仍然是电信诈骗犯罪不断蔓延的主要原因。电信诈骗犯罪智能化、。',
#                user_id:1,
#                article_type_id:1,
#                s_type:0)
# Article.create(title:'中国大陆,居民',
#                content:'尽管我国在打击电信诈骗犯罪方面取得了一些成效，但面对日益严峻的犯罪形势，打击治理工作还面临诸多问题和困难，难以从根本上遏制此类犯罪发展蔓延的势头。 据了解，侦破难度大，打击效果差仍然是电信诈骗犯罪不断蔓延的主要原因。电信诈骗犯罪智能化、。',
#                user_id:1,
#                article_type_id:1,
#                s_type:1)
# Article.create(title:'洋柿子鸡蛋汤哈、哈哈哈不太好吃也不太好喝',
#                content:'刘白菜的个人网站红红火火和还好还好，但面对日益严峻的犯罪形势，打击治理工作还面临诸多问题和困难，难以从根本上遏制此类犯罪发展蔓延的势头。 据了解，侦破难度大，打击效果差仍然是电信诈骗犯罪不断蔓延的主要原因。电信诈骗犯罪智能化、。',
#                user_id:1,
#                article_type_id:1,
#                s_type:1)
# Site.create(url:'http://www.v2258.com',
#             title:'澳门银河娱乐城',
#             reason:'系统提示取款，但是到不了账，客服也不理人',
#             short_reason:'黑客户存款',
#             count:12306,
#             images:'http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450109210e.png,http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450ff38b84.png',
#             note:'危险性高',
#             is_valid:true,
#             site_type_id:4)
# Site.create(url:'http://www.v2258.com',
#             title:'澳门金河娱乐城',
#             reason:'系统提示取款，但是到不了账，客服也不理人',
#             short_reason:'帮客户赚钱',
#             count:12358,
#             images:'http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450109210e.png,http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450ff38b84.png',
#             note:'危险性低',
#             is_valid:true,
#             site_type_id:3)
# Site.create(url:'http://www.v2258.com',
#             title:'澳门铜河娱乐城',
#             reason:'系统提示取款，但是到不了账，客服也不理人',
#             short_reason:'帮客户存款',
#             count:10001,
#             images:'http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450109210e.png,http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450ff38b84.png',
#             note:'危险性中',
#             is_valid:true,
#             site_type_id:3)
# Site.create(url:'http://www.v2258.com',
#             title:'澳门铁河娱乐城',
#             reason:'系统提示取款，但是到不了账，客服也不理人',
#             short_reason:'给客户存款',
#             count:10086,
#             images:'http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450109210e.png,http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450ff38b84.png',
#             note:'危险性高',
#             is_valid:true,
#             site_type_id:2)
# Site.create(url:'http://www.v2258.com',
#             title:'澳门铝合金河娱乐城',
#             reason:'系统提示取款，但是到不了账，客服也不理人',
#             short_reason:'嘿嘿客户存款',
#             count:10010,
#             images:'http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450109210e.png,http://www.ocrc.asia/Attached/thumbs/2016-07-12/578450ff38b84.png',
#             note:'危险性高',
#             is_valid:true,
#             site_type_id:4)
# Message.create(content:'艾玛我好痒啊啊啊啊啊',
#                sender:1,
#                user_id:1)
# Message.create(content:'艾玛我好痒啊啊dfdfdf啊啊啊',
#                sender:1,
#                user_id:1)
# Message.create(content:'艾玛我好ggggggggg痒啊啊啊啊啊',
#                sender:1,
#                user_id:1)

system('rake environment elasticsearch:import:model CLASS=\'Article\' FORCE=y')
system('rake environment elasticsearch:import:model CLASS=\'Site\' FORCE=y')
system('rake environment elasticsearch:import:model CLASS=\'User\' FORCE=y')