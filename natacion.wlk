import estilos.*

class Estudiante{
    const estilos  //coleccion tipo set
    const edad

    method estilos() {
      return estilos
    }

    method edad() {
      return edad
    }

    method dominaElEstilo(estilo) {
      return estilos.contains(estilo)
    }
    
    method dominAlMenosUnEstilo() {
      return not estilos.isEmpty()
    }

    method tieneAlmenosUnEstiloRelajante() {
      return estilos.any({estilo => estilo.esRelajante()})
    }

    method esMenorA13() {
      return edad < 13
    }

    method descuentoPorSusEstilo() {
      return 20 - estilos.sum({estilo => estilo.descuento()})
    }
}

class Curso {
    const docente
    const cupoMaximo
    const estudiantesInscriptos //coleccion tipo set

    method docente() {
      return docente
    }

    method estudiantesInscriptos() {
      return estudiantesInscriptos
    }

    method puedeInscribirAEstudiante(estudiante) {
      return not self.estaInscripto(estudiante)            &&
             estudiantesInscriptos.size() < cupoMaximo &&
             self.docenteEstaHabilitado(estudiante,self)    &&
             self.puedeAceptarAEstudiante(estudiante)
    }

    method estaInscripto(estudiante) {
      return estudiantesInscriptos.contains(estudiante)
    }

    method docenteEstaHabilitado(estudiante,curso) {
      return docente.puedeDictarClase(estudiante,curso)
    }

    method puedeAceptarAEstudiante(estudiante)

    method inscribirAEstudiante(estudiante) {
      self.ValidarInscripcionDeEstudiante(estudiante)
      estudiantesInscriptos.add(estudiante)
    }

    method ValidarInscripcionDeEstudiante(estudiante) {
      if(!self.puedeInscribirAEstudiante(estudiante)){
        self.error("no puede inscribirse al curso")
      }
    }

    method cantidadEstudiantesMenoresA13() {
      return estudiantesInscriptos.count({estudiante => estudiante.esMenorA13()})
    }


    method cantidadEstudiantesIncriptos() {
      return estudiantesInscriptos.size()
    }

    method recaudacionBruta(){
        return self.recaudacionDeCurso() - docente.honorariosDocente(self.recaudacionDeCurso(),self)
    }

    method recaudacionDeCurso() {
      return estudiantesInscriptos.sum({estudiante => estudiante.descuentoPorSusEstilo()})
    }

    method esCursoConEstilo(estilo) {
      return estudiantesInscriptos.any({estudiante => estudiante.dominaElEstilo(estilo)})
    }

    method esCursoInfantil() {
      return estudiantesInscriptos.all({estudiante => estudiante.esMenorA13()})
    }
}

class Base inherits Curso {
    override method puedeAceptarAEstudiante(estudiante) {
        return estudiante.dominAlMenosUnEstilo() || docente.esGuardaVida()
    }
}

class EscuelitaDeNiños inherits Base {
    override method puedeAceptarAEstudiante(estudiante) {
        return super(estudiante) && estudiante.edad() < 13
    }

    override method recaudacionDeCurso(){
        return super() + 500
    }
}

class Terapeuticos inherits Curso {
    const recaudacionBruta
    override method puedeAceptarAEstudiante(estudiante) {
        return estudiante.tieneAlmenosUnEstiloRelajante()
    }

    override method recaudacionDeCurso(){ //NO ES EL MEJOR NOMBRE
        return recaudacionBruta
    }
}

class Docente {
    const esGuardaVida
    method puedeDictarClase(estudiante,curso)

    method esGuardaVida() {
      return esGuardaVida
    }

    method honorariosDocente(recaudacionDeCurso,curso) {
      return 20 + recaudacionDeCurso * self.porcentajeRecaudacion(curso)
    }

    method porcentajeRecaudacion(curso) {
      return 0.1
    }
}

class Dedicado inherits Docente {
    const estilo
    override method puedeDictarClase(estudiante,curso) {
        return estudiante.dominaElEstilo(estilo)
    }

    override method porcentajeRecaudacion(curso) {
        return 0.15
    }
}

class Externo inherits Docente {
    const limiteMenores
    override method puedeDictarClase(estudiante,curso) {
        return estudiante.edad() > 13 || curso.cantidadEstudiantesMenoresA13() < limiteMenores
    }

    override method honorariosDocente(recaudacionDeCurso,curso) {
      return super(recaudacionDeCurso,curso) + 3 *  curso.cantidadEstudiantesIncriptos()
    }
}

class Basico inherits Docente {
    override method puedeDictarClase(estudiante,curso) {
        return true
    }
}

class Escuela {
    var dineroGuardado
    const cursos

    method dineroGuardado() {
      return dineroGuardado
    }

    method cobrarRecaudacion() {
      dineroGuardado += self.recaudacionMensual()
    }

    method recaudacionMensual() {
      return cursos.sum({curso => curso.recaudacionBruta()})
    }

    method cursoConEstilo(estilo) {
      return cursos.find({curso => curso.esCursoConEstilo(estilo)})
    }

    method cursosInfantiles() {
      return cursos.filter({curso => curso.esCursoInfantil()})
    }

    method docentesDeCursosInfantiles() {
      return self.cursosInfantiles().map({curso => curso.docente()})
    }

}