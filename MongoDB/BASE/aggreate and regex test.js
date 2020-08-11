/*
  $facet : 하나의 스테이지 안에 여러 파이프라인 구성
  $project : 파이프라인을 재구성 하는 역할 
  $group : 해당 필드를 기준으로 집계 하는 역할
  $sum : 해당 필드를 합산 하는 역할
  $sort : 정렬의 역할 _id : 1(오름차순), _id : -1(내림차순)
  $limit : 출력할 데이터 갯수를 제한 하는 역할
  $match : 해당 필드에 매칭되는 도큐먼트를 출력하는 역할

*/


//로또 1번~6번까지의 자릿수별 숫자가 나온 횟수 합계
db.TblLottoNumber.aggregate([
   { '$facet' : {
                    'FisrtCount'   : [{'$group' : {'_id' : '$one'  , 'Count' : {'$sum' : 1}}}, {'$sort' : {'Count' : -1}}],
                    'TwoCount'     : [{'$group' : {'_id' : '$two'  , 'Count' : {'$sum' : 1}}}, {'$sort' : {'Count' : -1}}],
                    'ThreeCount'   : [{'$group' : {'_id' : '$Three', 'Count' : {'$sum' : 1}}}, {'$sort' : {'Count' : -1}}],
                    'FourCount'    : [{'$group' : {'_id' : '$Four' , 'Count' : {'$sum' : 1}}}, {'$sort' : {'Count' : -1}}],
                    'FiveCount'    : [{'$group' : {'_id' : '$Five' , 'Count' : {'$sum' : 1}}}, {'$sort' : {'Count' : -1}}],
                    'SixCount'     : [{'$group' : {'_id' : '$Six'  , 'Count' : {'$sum' : 1}}}, {'$sort' : {'Count' : -1}}],
                    'BonusCount'   : [{'$group' : {'_id' : '$Bonus', 'Count' : {'$sum' : 1}}}, {'$sort' : {'Count' : -1}}]
                }
   }   
   
])
   
//로또의 1번 ~45번 의 숫자가 나온 횟수를 표현
db.TblLottoNumber.aggregate([

   { '$facet' : {
                    'FisrtCount'   : [{'$group' : {'_id' : '$one'   , 'Count' : {'$sum' : 1}}}],
                    'TwoCount'     : [{'$group' : {'_id' : '$two'   , 'Count' : {'$sum' : 1}}}],
                    'ThreeCount'   : [{'$group' : {'_id' : '$Three' , 'Count' : {'$sum' : 1}}}],
                    'FourCount'    : [{'$group' : {'_id' : '$Four'  , 'Count' : {'$sum' : 1}}}],
                    'FiveCount'    : [{'$group' : {'_id' : '$Five'  , 'Count' : {'$sum' : 1}}}],
                    'SixCount'     : [{'$group' : {'_id' : '$Six'   , 'Count' : {'$sum' : 1}}}],
                    'BonusCount'   : [{'$group' : {'_id' : '$Bonus' , 'Count' : {'$sum' : 1}}}]
                }
   },
   {'$project' : {'LottoCount' : ['$FisrtCount', '$TwoCount', '$ThreeCount', '$FourCount', '$FiveCount', '$SixCount', '$BonusCount']}},
   {'$unwind' : '$LottoCount'},
   {'$unwind' : '$LottoCount'},
   {'$group'  : {'_id' : '$LottoCount._id', 'Count' : {'$sum' : '$LottoCount.Count'}}},
   {'$sort'   : {'_id' : 1}}
])
   
   
db.TblLottoLocal.aggregate([
    {'$match' : {'Area' : '서울'}},
    {'$group' : {'_id' : '$Addr', 'count' : {'$sum' : 1}}},
    {'$sort'  : {'count' : -1}},
    {'$limit' : 5}

])


db.TblLottoLocal.aggregate([
    {'$match' : {'City' : '종로구'}},
    {'$group' : {'_id' : '$Addr', 'count' : {'$sum' : 1}}},
    {'$sort'  : {'count' : -1}},
    {'$limit' : 5}

])

/*
 $gte : 해당 내역 이상의 필드 출력, 
 $lte : 해당 내역 이하의 필드 출력
 로또 1번 ~ 6번까지 자릿수별 숫자가 나온 횟수 총합계
*/
db.TblLottoNumber.aggregate([

   { '$facet' : {
                    'FisrtCount'   : [{'$group' : {'_id' : '$one'   , 'Count' : {'$sum' : 1}}}],
                    'TwoCount'     : [{'$group' : {'_id' : '$two'   , 'Count' : {'$sum' : 1}}}],
                    'ThreeCount'   : [{'$group' : {'_id' : '$Three' , 'Count' : {'$sum' : 1}}}],
                    'FourCount'    : [{'$group' : {'_id' : '$Four'  , 'Count' : {'$sum' : 1}}}],
                    'FiveCount'    : [{'$group' : {'_id' : '$Five'  , 'Count' : {'$sum' : 1}}}],
                    'SixCount'     : [{'$group' : {'_id' : '$Six'   , 'Count' : {'$sum' : 1}}}],
                    'BonusCount'   : [{'$group' : {'_id' : '$Bonus' , 'Count' : {'$sum' : 1}}}]
                }
   },
   {'$project' : {'LottoCount' : ['$FisrtCount', '$TwoCount', '$ThreeCount', '$FourCount', '$FiveCount', '$SixCount', '$BonusCount']}},
   {'$unwind' : '$LottoCount'},
   {'$unwind' : '$LottoCount'},
   {'$group'  : {'_id' : '$LottoCount._id', 'Count' : {'$sum' : '$LottoCount.Count'}}},
   {'$sort'   : {'Count' : -1, '_id' : 1}},
   {'$facet'  : {'FirstSection' : [{'$match' : {'_id' : {'$gte' : 1, '$lte' : 10}}},
                                   {'$group' : {'_id' : null, 'Count' : {'$sum' : '$Count'}}}],
                 'TwoSection'   : [{'$match' : {'_id' : {'$gte' : 11, '$lte' : 20}}},
                                   {'$group' : {'_id' : null, 'Count' : {'$sum' : '$Count'}}}],
                 'ThreeSection' : [{'$match' : {'_id' : {'$gte' : 21, '$lte' : 30}}},
                                   {'$group' : {'_id' : null, 'Count' : {'$sum' : '$Count'}}}],
                 'FourSection ' : [{'$match' : {'_id' : {'$gte' : 31, '$lte' : 40}}},
                                   {'$group' : {'_id' : null, 'Count' : {'$sum' : '$Count'}}}],
                 'FiveSection'  : [{'$match' : {'_id' : {'$gte' : 41, '$lte' : 45}}},
                                   {'$group' : {'_id' : null, 'Count' : {'$sum' : '$Count'}}}]                 
                                   
                }
   
   }
 
])   

/*
 $regex : 정규표현식으로 patter과 일치하는 도큐먼트 출력
 지역이 강북에 해당되는 도큐먼트 출력
*/   
db.TblLottoLocal.aggregate([
    {'$match' : { 'Area' : '서울',
                  'Addr' : {'$regex' : /강북/}
                }
    
    },
    {'$group' : {'_id'  : '$Addr', 'count' : {'$sum' : 1}}},
    {'$sort' : {'count' : -1}}
])

    

db.TblLottoLocal.aggregate([
    {'$match' : { 'Area' : '서울',
                  'Addr' : {'$regex' : '강북'}
                }
    
    },
    {'$group' : {'_id'  : '$Addr', 'count' : {'$sum' : 1}}},
    {'$sort' : {'count' : -1}}
])


   