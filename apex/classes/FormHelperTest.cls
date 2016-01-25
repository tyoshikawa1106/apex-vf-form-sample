@isTest
private class FormHelperTest {

    private static FormHelper helper = new FormHelper();
    private static User testAdminUser = new User(Id = UserInfo.getUserId());

    /**
     * ファイル選択チェック
     * 値なし
     */
    static testMethod void checkIsSelectFileErrorTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            Blob uploadFile = null;
            Boolean isError = helper.checkIsSelectFileError(uploadFile);
            
            Test.stopTest();

            System.assertEquals(isError, true);
        }
    }

    /**
     * ファイル選択チェック
     * 値あり
     */
    static testMethod void checkIsSelectFileErrorTest2() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            Blob uploadFile = Blob.valueOf('Sample File');
            Boolean isError = helper.checkIsSelectFileError(uploadFile);
            
            Test.stopTest();

            System.assertEquals(isError, false);
        }
    }

    /**
     * ファイルサイズチェック
     * 値なし
     */
    static testMethod void checkIsFileSizeErrorTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            Long fileSize = null;
            Boolean isError = helper.checkIsFileSizeError(fileSize);
            
            Test.stopTest();

            System.assertEquals(isError, false);
        }
    }

    /**
     * ファイルサイズチェック
     * 値あり
     */
    static testMethod void checkIsFileSizeErrorTest2() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            // ファイルサイズ = 0
            Long fileSize = 0;
            Boolean isError = helper.checkIsFileSizeError(fileSize);
            System.assertEquals(isError, false);

            // ファイルサイズ = 上限値と同じ値
            fileSize = 1242880;
            isError = helper.checkIsFileSizeError(fileSize);
            System.assertEquals(isError, false);

            // ファイルサイズ = 上限値より大きい
            fileSize = 1242880 + 1;
            isError = helper.checkIsFileSizeError(fileSize);
            System.assertEquals(isError, true);
            
            Test.stopTest();
        }
    }

    /**
     * ファイルサイズのMB変換
     */
    static testMethod void converFileSizeMegaByteTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            // 値なし
            Long fileSize = null;
            Decimal result = helper.converFileSizeMegaByte(fileSize);
            System.assertEquals(result, 0);

            // 値あり 
            fileSize = 0;
            result = helper.converFileSizeMegaByte(fileSize);
            System.assertEquals(result, 0);

            // 値あり 
            fileSize = 1048576;
            result = helper.converFileSizeMegaByte(fileSize);
            System.assertEquals(result, 1);
            
            Test.stopTest();
        }
    }

    /**
     * 不正な操作のチェック
     */
    static testMethod void checkIsCorrectErrorTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            // 正常フラグ = false
            Boolean isCorrect = false;
            Boolean isError = helper.checkIsCorrectError(isCorrect);
            System.assertEquals(isError, true);

            // 正常フラグ = true
            isCorrect = true;
            isError = helper.checkIsCorrectError(isCorrect);
            System.assertEquals(isError, false);
            
            Test.stopTest();
        }
    }

    /**
     * ファイル拡張子を判定
     */
    static testMethod void checkFileTypeErrorTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            // 値なし
            String fileName = '';
            Boolean isError = helper.checkFileTypeError(fileName);
            System.assertEquals(isError, true);

            // xls
            fileName = 'sample.xls';
            isError = helper.checkFileTypeError(fileName);
            System.assertEquals(isError, false);

            // xlsx
            fileName = 'sample.xlsx';
            isError = helper.checkFileTypeError(fileName);
            System.assertEquals(isError, false);

            // doc
            fileName = 'sample.doc';
            isError = helper.checkFileTypeError(fileName);
            System.assertEquals(isError, false);

            // docx
            fileName = 'sample.docx';
            isError = helper.checkFileTypeError(fileName);
            System.assertEquals(isError, false);

            // pdf
            fileName = 'sample.pdf';
            isError = helper.checkFileTypeError(fileName);
            System.assertEquals(isError, false);

            // 対象外
            fileName = 'sample.jpg';
            isError = helper.checkFileTypeError(fileName);
            System.assertEquals(isError, true);
            
            Test.stopTest();
        }
    }

    /**
     * 登録用の添付ファイル情報取得
     * 値なし
     */
    static testMethod void getAttachmentTest1() {
        
        System.runAs(testAdminUser) {

            Test.startTest();
            
            String fileName = 'sample.xls';
            Blob uploadFile = Blob.valueOf('Test File');
            Id parentId = null;
            Attachment result = helper.getAttachment(fileName, uploadFile, parentId);
            
            Test.stopTest();

            System.assertEquals(String.isEmpty(result.Name), true);
        }
    }

    /**
     * 登録用の添付ファイル情報取得
     * 値あり
     */
    static testMethod void getAttachmentTest2() {
        
        System.runAs(testAdminUser) {

            Contact contact = new Contact(LastName = 'Yoshikawa');
            insert contact;
            System.assertEquals(String.isNotEmpty(contact.Id), true);

            Test.startTest();
            
            String fileName = 'sample.xls';
            Blob uploadFile = Blob.valueOf('Test File');
            Id parentId = contact.Id;
            Attachment result = helper.getAttachment(fileName, uploadFile, parentId);
            
            Test.stopTest();

            System.assertEquals(result.Name, fileName);
            System.assertEquals(result.ParentId, contact.Id);
        }
    }
}