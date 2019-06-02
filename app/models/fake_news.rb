class FakeNews < ApplicationRecord
    mount_uploader :thumb_nail, ImageUploader
 
    # 이미지를 가진 게시글 삭제 시 AWS S3서버에도 자동 삭제처리
    before_destroy :destroy_assets
 
    def destroy_assets
        self.thumb_nail.remove! if self.thumb_nail
        self.save!
    end
end
