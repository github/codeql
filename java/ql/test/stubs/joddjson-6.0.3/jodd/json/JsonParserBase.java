// Copyright (c) 2003-present, Jodd Team (http://jodd.org)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

package jodd.json;

import java.util.Collection;

/**
 * Just a base class of {@link jodd.json.JsonParser} that contains
 * various utilities, to reduce the size of a parser.
 */
public abstract class JsonParserBase {
	public JsonParserBase(final boolean strictTypes) {
	}

	/**
	 * Creates new instance of {@link jodd.json.MapToBean}.
	 */
	protected MapToBean createMapToBean(final String classMetadataName) {
		return null;
	}

	/**
	 * Creates new type for JSON array objects.
	 * It returns a collection.
	 * Later, the collection will be converted into the target type.
	 */
	@SuppressWarnings("unchecked")
	protected Collection<Object> newArrayInstance(final Class targetType) {
		return null;
	}

	/**
	 * Creates new object or a <code>HashMap</code> if type is not specified.
	 */
	protected Object newObjectInstance(final Class targetType) {
		return null;
	}

	/**
	 * Converts type of the given value.
	 */
	protected Object convertType(final Object value, final Class targetType) {
		return null;
	}
}
