<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../../../favicon.ico">

    <title>Dashboard Template for Bootstrap</title>

    <!-- Bootstrap core CSS -->
    <link href="/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="/dashboard.css" rel="stylesheet">
</head>

<style>
    body{
        background-image: url("http://www.htmlcsscolor.com/preview/gallery/C0D0E5.png");
        color: white;
    }
</style>
<body>

<div class="container-fluid">
    <div class="row">


        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
                <h1 class="h2">GRÁFICOS</h1>

            </div>

            <canvas class="my-4" id="chart" width="900" height="380"></canvas>


            <br>
            <br>


            <canvas class="my-4" id="humedad" width="900" height="380"></canvas>


        </main>
    </div>
</div>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
        integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
        crossorigin="anonymous"></script>
<script src="../static/js/bootstrap.min.js"></script>

<!-- Icons -->
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>

<!-- Graphs -->
<script src="/echarts.min.js"></script>
<script>

    let chartTemperatura, chartHumedad;
    let dataTemperatura = [], dataHumedad = [];
    let ejeXTemperatura = [], ejeXHumedad = [];
    let webSocket;
    let tiempoReconectar = 5000;

    $(document).ready(function () {

        grafico1();

        grafico2();
    });

    function grafico1() {

        let option;
        option = {
            title: {
                text: 'Temperatura'
            },
            tooltip: {
                trigger: 'axis',
                // formatter: function (params) {
                //
                //     // console.log(params);
                //     return params[0].axisValue + ' ' + params[0].value[1];
                // }


            },
            xAxis: {
                type: 'category',
                data: ejeXTemperatura,
                splitLine: {
                    show: false
                }
            },
            yAxis: {
                type: 'value',
                boundaryGap: [0, '100%'],
                splitLine: {
                    show: false
                }
            },
            series: [{
                data: [0],
                type: 'line',
                hoverAnimation: false,
            }],
            color: ['rgb(30,180,255)'],


        };

        chartTemperatura = echarts.init(document.getElementById("chart"));
        chartTemperatura.setOption(option);

    }

    function grafico2() {

        let option;
        option = {
            title: {
                text: 'Humedad'
            },
            tooltip: {
                trigger: 'axis',


            },
            xAxis: {
                type: 'category',
                data: ejeXHumedad,
                splitLine: {
                    show: false
                }
            },
            yAxis: {
                type: 'value',
                boundaryGap: [0, '100%'],
                splitLine: {
                    show: false
                }
            },
            series: [{
                data: [0],
                type: 'line',
                hoverAnimation: false,
            }],
            color: ['rgb(255,239,92)'],


        };

        chartHumedad = echarts.init(document.getElementById("humedad"));
        chartHumedad.setOption(option);

    }

    function nuevoValor(datos) {

        let nuevo = JSON.parse(datos);
        // console.log(nuevo);
        // data.shift();
        dataTemperatura.push(nuevo.temperatura);
        dataHumedad.push(nuevo.humedad);

        // ejeX.shift();
        ejeXTemperatura.push(nuevo.fecha);
        ejeXHumedad.push(nuevo.fecha);

        chartTemperatura.setOption({
            xAxis: {
                data: ejeXTemperatura
            },

            series: [{
                data: dataTemperatura
            }]

        });

        chartHumedad.setOption({
            xAxis: {
                data: ejeXHumedad
            },

            series: [{
                data: dataHumedad
            }]

        });
    }


    function conectar() {//ahi se conecta el websocket para mandar el mensaje que ta aqui abajo.. se usa json para enviarlo
        webSocket = new WebSocket("ws://" + location.hostname + ":" + location.port + "/nuevoMensaje");
        webSocket.onmessage = function (datos) {
            // console.log(datos);
            nuevoValor(datos.data);
        };
    }

    function verificarConexion() {
        if (!webSocket || webSocket.readyState === 3) {
            conectar();
        }
    }

    setInterval(verificarConexion, tiempoReconectar);

</script>
</body>
</html>
