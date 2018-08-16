Describe "postbuild-copy-docker" {
  $cid = docker run --rm -d -v "$(Convert-Path '.\wwwroot'):C:\wwwroot" postbuild-copy-docker
  $ip = docker inspect $cid --format "{{ .NetworkSettings.Networks.nat.IPAddress }}"

  # Give it a bit for .\Start.ps1 to complete
  Start-Sleep -Seconds 10

  It "Should serve index.html" {
    $response = Invoke-WebRequest "http://$($ip)/" -UseBasicParsing
    $response | Should -Not -Be $null
    $response.StatusCode | Should -Be 200
    $response.Content | Should -Be (Get-Content ".\wwwroot\index.html" -Raw)
  }

  docker stop $cid
}