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
}

class Curso {
    const docente
    const cupoMaximo
    const estudiantesInscriptos //coleccion tipo set

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
}

class Terapeuticos inherits Curso {
    override method puedeAceptarAEstudiante(estudiante) {
        return estudiante.tieneAlmenosUnEstiloRelajante()
    }
}

class Docente {
    const esGuardaVida
    method puedeDictarClase(estudiante,curso)

    method esGuardaVida() {
      return esGuardaVida
    }
}

class Dedicado inherits Docente {
    const estilo
    override method puedeDictarClase(estudiante,curso) {
        return estudiante.dominaElEstilo(estilo)
    }
}

class Externo inherits Docente {
    const limiteMenores
    override method puedeDictarClase(estudiante,curso) {
        return estudiante.edad() > 13 || curso.cantidadEstudiantesMenoresA13() < limiteMenores
    }
}

class Basico inherits Docente {
    override method puedeDictarClase(estudiante,curso) {
        return true
    }
}