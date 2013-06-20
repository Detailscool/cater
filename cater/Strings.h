#define PROJECT_NAME @"聚牛叉"

// 将int类型转换为NSString
#define int2str(param) [NSString stringWithFormat:@"%d",param]

// 全局背景
#define kGlobalBackgroundColor [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[@"buy_car_bg" imageFullPath]]]

// 公共标识(一般用在cell中)
#define IDENTIFIER @"identifier"

// 生成请求的url http://sz.8color.cn/
#define url(param) [@"http://sz.8color.cn/" stringByAppendingString:param]

// UserInfo的key
#define BEAN @"bean"
#define DATA @"data"

#define LOAD_TITLE @"正在努力加载数据..." // 默认loading的标题
// 请求成功的通知
#define REQUEST_SUCCESS @"request_success"
// 请求失败的通知
#define REQUEST_FAILURE @"request_failure"

// 错误信息的key
#define ERROR_MSG @"errorMsg"
#define ERROR_MSG2 @"key"

#define PAI_ZHAO @"拍照"
#define XIANG_CE @"从相册上传"
#define QU_XIAO @"取消"
// 请求失败
#define NETWORK_ERROR @"系统繁忙, 请稍后再试"
#define DOWNLOAD_ERROR @"系统繁忙, 请稍后再试"
#define UPLOAD_ERROR @"系统繁忙, 请稍后再试"
#define NO_NETWORK @"请检查网络设置"

#define BOOK_CATER @"预定餐厅"
#define ORDER_DISH @"我要点菜"
#define TUAN_GOU @"团购"
#define USER_DATA @"用户信息"
#define RECOMMAND @"菜品推荐"

#define SETTING @"设置"
//是否已经登录的key
#define LOGINED @"logined"

//成功添加购物车
#define ADD_CAR_SUCCESS @"addCarSuccess"
//从购物车删除成功
#define DELETE_CAR_SUCCESS @"deleteCarSuccess"
#define BTN_NORMAL @"cancel_order"

#define BTN_PRESSED @"order_dish"

#define ORDER_CATER @"点菜"

#define CANCEL @"取消"

#define RESULT @"result"
#define PAGE_NO @"pageNo"
#define NUM @"num"
#define TOTAL_PAGES @"totalPages"
#define DATA @"data"
#define PAGESIZE @"pageSize"

#define KEY @"key"
#define PRICE @"price"
#define NAME @"name"
#define ID @"id"
#define IMAGE_URL @"imageUrl"
#define CP_INFO @"info"