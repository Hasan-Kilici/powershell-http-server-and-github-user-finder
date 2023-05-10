$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$http = [System.Net.HttpListener]::new() 

$http.Prefixes.Add("http://localhost:8080/")

$http.Start()


if ($http.IsListening) {
    write-host " HTTP Server Ready!  " -f 'black' -b 'gre'
    write-host "now try going to $($http.Prefixes)" -f 'y'
    write-host "then try going to $($http.Prefixes)other/path" -f 'y'
}

while ($http.IsListening) {

    $context = $http.GetContext()

    if ($context.Request.HttpMethod -eq 'GET' -and $context.Request.RawUrl -eq '/') {

        write-host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'mag'

        [string]$html = "<html><head><link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ' crossorigin='anonymous'><title>Anasayfa</title><head><body class='bg-dark'><div class='container-fluid'><div class='container text-white'><h1>Powershell Github User Finder OMGG!!!</h1></div></div><form method='POST' action='/find/user'><input id='username' name='username'><input type='submit'></form></body></html>" 
        
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close()
    
    }

    if ($context.Request.HttpMethod -eq 'POST' -and $context.Request.RawUrl -eq '/find/user') {

        $FormContent = [System.IO.StreamReader]::new($context.Request.InputStream).ReadToEnd()
        Write-host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'mag'
        Write-Host $FormContent.Split("=")[1] -f 'Green'
        $username = $FormContent.Split("=")[1]
        [string]$html = "<html><head><link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ' crossorigin='anonymous'><title>Anasayfa</title><head><body class='bg-dark text-white'><div class='container-fluid'><div class='container text-white'><h1>Powershell Github User Finder OMGG!!!</h1></div></div><form method='POST' action='/find/user'><input id='username' name='username'><input type='submit'></form><script>
        fetch('https://api.github.com/users/$username').then(async(data)=>{
        let a = await data.json(); 
        document.getElementById('following').innerHTML = a.following;
        document.getElementById('followers').innerHTML = a.followers;
        })
        </script><br><h3 class='text-danger' id='username'>$username</h3><label id='followers'></label><br><label id='following'></label></body><html>" 

        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $context.Response.ContentLength64 = $buffer.Length
        $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        $context.Response.OutputStream.Close() 
    }


} 


$host.UI.RawUI.ForegroundColor = "Green"
