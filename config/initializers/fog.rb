CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
    provider:              'AWS',                        # required
        aws_access_key_id:     'erfw35324e3e',                        # required
        aws_secret_access_key: 'wqe2q4213213',                        # required
        region:                'ap-northeast-2',             # 아시아-한국서버 명칭
        endpoint:              'https://s3-ap-northeast-2.amazonaws.com' # 아시아-한국서버
    }
    config.fog_directory  = 'bracket'                          # required
    config.fog_public     = true                                        # optional, defaults to true
    config.fog_attributes = { } # optional, defaults to {}
    
    # 이미지를 가진 게시글 삭제 시 AWS S3서버에도 자동 삭제처리
    config.remove_previously_stored_files_after_update = true
end