//
//  GSDefine.hpp
//  GroupShot
//
//  Created by kjh on 2018/4/3.
//  Copyright © 2018年 kjh. All rights reserved.
//

#ifndef GSDefine_hpp
#define GSDefine_hpp

#ifndef SAFE_DELETE
#define SAFE_DELETE(x) { if(x) delete (x); (x) = NULL;}
#endif
#ifndef SAFE_DELETE_ARRAY
#define SAFE_DELETE_ARRAY(x) { if (x) delete [] (x); (x) = NULL; }
#endif
#endif /* GSDefine_hpp */
