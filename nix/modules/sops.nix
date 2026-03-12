{ config, pkgs, ... }:

{
  sops = {
    # .sops.yaml에서 정의한 암호화된 파일 경로
    defaultSopsFile = ../../secrets.yaml;
    
    # SSH 키를 age 키로 변환하여 사용하도록 설정
    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    
    # 비밀번호 정의
    secrets.gemini_api_key = {
      key = "gemini_api_key"; # secrets.yaml 안의 'gemini_api_key' 필드 값만 추출
    };
  };

  # 쉘 환경 변수에 등록 (비밀번호 값이 아닌 '경로'를 등록)
  home.sessionVariables = {
    GEMINI_API_KEY_FILE = config.sops.secrets.gemini_api_key.path;
  };
}
