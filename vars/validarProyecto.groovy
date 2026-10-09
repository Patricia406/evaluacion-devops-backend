
def call() {
    echo 'Validando entorno del proyecto Node.js'

    sh 'node --version'
    sh 'npm --version'

    echo 'Validacion del entorno completada'
}
