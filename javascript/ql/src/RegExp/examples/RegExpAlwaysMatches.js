if (!/[a-z0-9]*/.test(id)) {
    throw new Error("Invalid id: " + id);
}
