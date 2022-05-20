
#Relies on __del__ being called by the garbage collector.
class CachedPreferencesFile

    ...

    def __del__(self):
        for key, value in self.preferences.items():
            self.write_pair(key, value)
        self.backing.close()


#Better version
class CachedPreferencesFile

    ...

    def close(self):
        for key, value in self.preferences.items():
            self.write_pair(key, value)
        self.backing.close()

    def __del__(self):
        self.close()
