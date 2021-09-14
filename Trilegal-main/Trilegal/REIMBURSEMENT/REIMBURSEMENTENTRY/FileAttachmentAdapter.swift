//
//  FileAttachmentAdapter.swift
//  Trilegal
//
//  Created by Acxiom Consulting on 15/07/21.
//  Copyright © 2021 Acxiom Consulting. All rights reserved.
//
//create table if not exists  AttachmentFileDetails(filename text,fileStr text ,id text,post text,extension text,fileid text)

import Foundation

class FileAttachmentAdapter{
    var filename: String?
    var fileStr: String?
    var id: String?
    var post: String?
    var extensionStr: String?
    var fileid: String?
 
    init(filename:String?,fileStr: String?,id: String?, post: String?,extensionStr: String? , fileid :String?) {
        self.filename = filename
        self.fileStr = fileStr
        self.id = id
        self.post = post
        self.extensionStr = extensionStr
        self.fileid = fileid
    }
}

