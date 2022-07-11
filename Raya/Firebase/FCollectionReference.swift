//
//  FCollectionReference.swift
//  Raya
//i هاض الكولكشن عشان ما اضل اعرف متغير واربطه ف الفاير بيس خلص بعرف زي فنكشن دايما وبستدعيها وهي بتعمل كلشي ومن هلحكي
//  Created by Yahya haj ali  on 25/03/2022.
//

import Foundation
import Firebase


enum FCollectionReference: String {
    case User
    case Chat
    case Message
    case Typing
    case Channel
}


func FirestoreReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}

