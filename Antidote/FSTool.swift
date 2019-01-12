//
//  FSTool.swift
//  Antidote
//
//  Created by hllly on 2019/1/11.
//  Copyright © 2019年 dvor. All rights reserved.
//

import Foundation

class FSTool {
    fileprivate var manager = FileManager.default
    
    //创建目录
    func mkdir(dir: String){
        let completeDir = NSHomeDirectory() + dir
        try! manager.createDirectory(atPath: completeDir, withIntermediateDirectories: true, attributes: nil)
    }
    
    //浅遍历目录，即只遍历制定目录下一层级
    func simpleGothrough(dir: String) -> [String] {
        let urlForDocument = manager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:FileManager.SearchPathDomainMask.userDomainMask)
        let url = urlForDocument[0] as NSURL
        let contentsOfPath = try? manager.contentsOfDirectory(atPath: url.path!)
        //print("=============path:\(String(describing: contentsOfPath))")
        return contentsOfPath!
    }
    
    //深遍历目录，即递归遍历
    func deepGothrough(dir: String) -> FileManager.DirectoryEnumerator {
        let urlForDocument = manager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:FileManager.SearchPathDomainMask.userDomainMask)
        let url = urlForDocument[0] as NSURL
        let enumeratorAtPath = manager.enumerator(atPath: url.path!)
        //print("==============path:\(String(describing: enumeratorAtPath))")
        return enumeratorAtPath!
    }
    
    //判断某目录或文件是否存在
    func exist(path: String) -> Bool {
        let completePath: String = NSHomeDirectory() + path
        let exist = manager.fileExists(atPath: completePath)
        return exist
    }
    
    //创建文件
    func createFile(path: String){
        let urlForDocument = manager.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                                           in:FileManager.SearchPathDomainMask.userDomainMask)
        let url = urlForDocument[0] as NSURL
        let file = url.appendingPathComponent(path)
        let exist = manager.fileExists(atPath: file!.path)
        if !exist {
            let data = NSData(base64Encoded:"aGVsbG8gd29ybGQ=",options:.ignoreUnknownCharacters)
            let createSuccess = manager.createFile(atPath: file!.path,contents:data! as Data,attributes:nil)
            //print("=================result: \(createSuccess)")
        }
    }
    
    //删除文件
    func deleteFile(path: String){
        let srcUrl = NSHomeDirectory() + path
        try! manager.removeItem(atPath: srcUrl)
    }
    
    //复制文件
    func copy(src: String, to: String){
        let homeDirectory = NSHomeDirectory()
        let srcUrl = homeDirectory + src
        let toUrl = homeDirectory + to
        try! manager.copyItem(atPath: srcUrl, toPath: toUrl)
    }
    
    //移动文件
    func move(src: String, to: String){
        let homeDirectory = NSHomeDirectory()
        let srcUrl = homeDirectory + src
        let toUrl = homeDirectory + to
        try! manager.moveItem(atPath: srcUrl, toPath: toUrl)
    }
    
    //删除目录
    func rmdir(dir: String){
        let completeDir = NSHomeDirectory() + dir
        try! manager.removeItem(atPath: completeDir)
    }
    
    //删除目录下面的所有文件
    func deleteDirAndFiles(dir: String){
        let completeDir = NSHomeDirectory() + dir
        try! manager.removeItem(atPath: completeDir)
        try! manager.createDirectory(atPath: completeDir, withIntermediateDirectories: true,
                                               attributes: nil)
    }
    
    //读取文件
    func read(path: String) -> Data{
        let urlsForDocDirectory = manager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:FileManager.SearchPathDomainMask.userDomainMask)
        let docPath:NSURL = urlsForDocDirectory[0] as NSURL
        let file = docPath.appendingPathComponent(path)
        let readHandler = try! FileHandle(forReadingFrom:file!)
        return readHandler.readDataToEndOfFile()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
