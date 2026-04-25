package tools;

class Assets {
    public static function imageBG(weekName:String,image:String,?imageFolder:Bool):String {
        if (imageFolder == true){
            var data:String = 'BackGrounds/'+weekName+'/images/'+image;
            return data;
        }      
        else{
               var data:String = 'BackGrounds/'+weekName+"/"+image;
            return data;
        }
    }
}