module veterinaria::registro_veterinaria {
    use std::string::{String, utf8};
    use sui::vec_map::{Self, VecMap};
    
    
    // Objeto principal Veterinaria que almacena su nombre y un VecMap del dueño ID al Cliente
    public struct Veterinaria has key, store {
        id: UID,
        nombre_veterinaria: String,
        clientes: VecMap<u64, Cliente>,
    }

    // Estructura Cliente que tiene nombre y un vector de Mascotas
    public struct Cliente has copy, drop, store {
        nombre_dueno: String,
        mascotas: vector<Mascota>,
    }

    // Enum para las mascotas: Perro o Gato
    public enum Mascota has store, drop, copy {
        Perro(Perro),
        Gato(Gato),
    }

    // Estructura Perro con nombre, raza y edad
    public struct Perro has copy, drop, store {
        nombre: String,
        raza: String,
        edad: u8,
    }

    // Estructura Gato con nombre, raza y edad
    public struct Gato has copy, drop, store {
        nombre: String,
        raza: String,
        edad: u8,
    }

    #[error]
    const ID_YA_EXISTE: vector<u8> = b"ERROR el id ya existe";
    #[error]
    const ID_NO_EXISTE: vector<u8> = b"ERROR el id no existe";
    
    public fun crear_veterinaria(nombre: String, ctx: &mut TxContext) {

        let veterinaria = Veterinaria {
            id: object::new(ctx),
            nombre_veterinaria: nombre, 
            clientes: vec_map::empty()
        };

        transfer::transfer(veterinaria, tx_context::sender(ctx));

    }

    public fun agregar_cliente(veterinaria: &mut Veterinaria, id_dueno: u64, nombre_dueno: String) {
        assert!(!veterinaria.clientes.contains(&id_dueno), ID_YA_EXISTE);

        let cliente = Cliente {
            nombre_dueno, 
            mascotas: vector[]
        };

        veterinaria.clientes.insert(id_dueno, cliente);
    }

    public fun agregar_perro(veterinaria: &mut Veterinaria, id_dueno: u64, nombre: String, raza: String, edad: u8) {
        assert!(veterinaria.clientes.contains(&id_dueno), ID_NO_EXISTE);
        
        let nueva_mascota = Mascota::Perro(Perro {nombre, raza, edad});

        let cliente_ref = veterinaria.clientes.get_mut(&id_dueno);
        cliente_ref.mascotas.push_back(nueva_mascota);
    }

    public fun agregar_gato(veterinaria: &mut Veterinaria, id_dueno: u64, nombre: String, raza: String, edad: u8) {
        assert!(veterinaria.clientes.contains(&id_dueno), ID_NO_EXISTE);
        
        let nueva_mascota = Mascota::Gato(Gato {nombre, raza, edad});

        let cliente_ref = veterinaria.clientes.get_mut(&id_dueno);
        cliente_ref.mascotas.push_back(nueva_mascota);
    }

    public fun modificar_mascota(veterinaria: &mut Veterinaria, id_dueno: u64, indice_mascota: u64, nuevo_nombre: String, nueva_raza: String, nueva_edad: u8) {
        
        // Verificar que el cliente exista
        assert!(veterinaria.clientes.contains(&id_dueno), ID_NO_EXISTE);
    
        // Obtener referencia mutable al cliente
        let cliente_ref = veterinaria.clientes.get_mut(&id_dueno);

        // Verificar que el índice de la mascota sea válido
        assert!(indice_mascota < vector::length(&cliente_ref.mascotas), ID_NO_EXISTE);

        let mascota_ref = cliente_ref.mascotas.borrow_mut(indice_mascota);
        
        match (mascota_ref) {
            Mascota::Perro(perro) => {
                perro.nombre = nuevo_nombre;
                perro.raza = nueva_raza;
                perro.edad = nueva_edad;
            }, 
            Mascota::Gato(gato) => {
                gato.nombre = nuevo_nombre;
                gato.raza = nueva_raza;
                gato.edad = nueva_edad;
            }
        }
    }
}