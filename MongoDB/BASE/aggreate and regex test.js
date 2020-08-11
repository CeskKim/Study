/*
  $facet : �ϳ��� �������� �ȿ� ���� ���������� ����
  $project : ������������ �籸�� �ϴ� ���� 
  $group : �ش� �ʵ带 �������� ���� �ϴ� ����
  $sum : �ش� �ʵ带 �ջ� �ϴ� ����
  $sort : ������ ���� _id : 1(��������), _id : -1(��������)
  $limit : ����� ������ ������ ���� �ϴ� ����
  $match : �ش� �ʵ忡 ��Ī�Ǵ� ��ť��Ʈ�� ����ϴ� ����

*/


//�ζ� 1��~6�������� �ڸ����� ���ڰ� ���� Ƚ�� �հ�
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
   
//�ζ��� 1�� ~45�� �� ���ڰ� ���� Ƚ���� ǥ��
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
    {'$match' : {'Area' : '����'}},
    {'$group' : {'_id' : '$Addr', 'count' : {'$sum' : 1}}},
    {'$sort'  : {'count' : -1}},
    {'$limit' : 5}

])


db.TblLottoLocal.aggregate([
    {'$match' : {'City' : '���α�'}},
    {'$group' : {'_id' : '$Addr', 'count' : {'$sum' : 1}}},
    {'$sort'  : {'count' : -1}},
    {'$limit' : 5}

])

/*
 $gte : �ش� ���� �̻��� �ʵ� ���, 
 $lte : �ش� ���� ������ �ʵ� ���
 �ζ� 1�� ~ 6������ �ڸ����� ���ڰ� ���� Ƚ�� ���հ�
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
 $regex : ����ǥ�������� patter�� ��ġ�ϴ� ��ť��Ʈ ���
 ������ ���Ͽ� �ش�Ǵ� ��ť��Ʈ ���
*/   
db.TblLottoLocal.aggregate([
    {'$match' : { 'Area' : '����',
                  'Addr' : {'$regex' : /����/}
                }
    
    },
    {'$group' : {'_id'  : '$Addr', 'count' : {'$sum' : 1}}},
    {'$sort' : {'count' : -1}}
])

    

db.TblLottoLocal.aggregate([
    {'$match' : { 'Area' : '����',
                  'Addr' : {'$regex' : '����'}
                }
    
    },
    {'$group' : {'_id'  : '$Addr', 'count' : {'$sum' : 1}}},
    {'$sort' : {'count' : -1}}
])


   