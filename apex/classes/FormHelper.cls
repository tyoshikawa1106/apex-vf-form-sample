public with sharing class FormHelper {

    /**
     * コンストラクタ
     */
    public FormHelper() {
        
    }

    /**
     * ファイル選択チェック
     */
    public Boolean checkIsSelectFileError(Blob uploadFile) {
        if(uploadFile == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '添付ファイルが未選択です'));
            return true;
        }
        return false;
    }

    /**
     * ファイルサイズチェック
     */
    public Boolean checkIsFileSizeError(Long fileSize) {
        if(fileSize != null && fileSize > 1242880){
            Decimal fileSizeView = this.converFileSizeMegaByte(fileSize);
            String errorMsg = 'ファイルサイズの上限を超えています。1MB以内のファイルにしてください。 : [アップロードサイズ = 約' + fileSizeView + 'MB)]';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, errorMsg)); 
            return true;
        }
        return false;
    }

    /**
     * ファイルサイズのMB変換
     */
    public Decimal converFileSizeMegaByte(Long fileSize) {
        Decimal result = 0;
        if (fileSize != null) {
            result = Decimal.valueOf(fileSize / 1048576).setScale(1);
        }
        return result;
    }

    /**
     * 不正な操作のチェック
     */
    public Boolean checkIsCorrectError(Boolean isCorrect) {
        if (!isCorrect) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '登録フォームから操作してください'));
            return true;
        }
        return false;
    }

    /**
     * ファイル拡張子を判定
     */
    public Boolean checkFileTypeError(String fileName) {
        Boolean isError = true;

        if (fileName.endsWith('.xls')) {
            isError = false;
        } else if (fileName.endsWith('.xlsx')) {
            isError = false;
        } else if (fileName.endsWith('.doc')) {
            isError = false;
        } else if (fileName.endsWith('.docx')) {
            isError = false;
        } else if (fileName.endsWith('.pdf')) {
            isError = false;
        }

        if (isError) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ファイル拡張子が対象外です。Excel/Word/PDFファイルのいずれかを選択してください'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'アップロードファイル名 = ' + fileName));
        }

        return isError;
    }

    /**
     * 登録用の添付ファイル情報取得
     */
    public Attachment getAttachment(String fileName, Blob uploadFile, Id parentId) {
        if (String.isEmpty(parentId)) {
            return new Attachment();
        }

        Attachment attachment = new Attachment(
             Name = fileName
            ,Body = uploadFile
            ,ParentId = parentId
        );

        return attachment;
    }
}