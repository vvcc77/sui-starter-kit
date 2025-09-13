# Veterinaria — Sui Move (Bootcamp)

Proyecto final del bootcamp de Sui Move.  
Registro de clientes y mascotas (Perro/Gato). **La edad** se modela con un **Enum**:
`Edad { Cachorro, Adulto, Senior }`, mapeando automáticamente desde `u8` para no romper las firmas públicas.

---

## 📦 Publicaciones

- **Mainnet — Package ID:** `0x62e86a2a10f44c585387607d4651e025e77b065d10b6b265e1f049f62d3e567b`
- **Testnet — Package ID:** `0x5d7627d711d739a253e716271ef4dcc00f978dd41d0e870f39dba0dbf3e3cb50`
- **Move Registry:** 

**Módulos publicados:** `registro_veterinaria` (principal), `practica_sui`.

---

## 🗂 Estructura mínima
Se agregó:

public enum Edad has store, drop, copy {
    Cachorro, Adulto, Senior
}

Función auxiliar: edad_desde_u8(u8): Edad.

Perro.edad y Gato.edad ahora son Edad.

En agregar_perro, agregar_gato y modificar_mascota se convierte el u8 recibido a Edad con edad_desde_u8.

Beneficio: API pública se mantiene (recibe u8), pero la persistencia usa Enum como pidió el ejercicio.


---

