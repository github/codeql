function invk(obj, member) {
    if (!(member in obj))
        throw new Error("No such member: " + member);
    return obj[member]();
}