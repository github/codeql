import java.util.List;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

public class JaxbTest {
	@XmlRegistry
	public static class ObjectFactory {
		public AnnotatedObject createAnnotatedObject() {
			return new AnnotatedObject();
		}

		public PublicMemberObject createPublicMemberObject() {
			return new PublicMemberObject();
		}

		public FieldObject createFieldObject() {
			return new FieldObject();
		}
	}

	/**
	 * Verify that annotated fields work correctly.
	 */
	@XmlType
	@XmlAccessorType(XmlAccessType.NONE)
	public static class AnnotatedObject {
		@XmlElement
		private LiveEnum liveEnum;

		@XmlElement
		public List<UnnannotatedLiveClass> classes;

		private LiveEnum liveEnumProp;

		private LiveEnum deadLink;

		public void setLiveEnum(LiveEnum liveEnum) {
			this.liveEnum = liveEnum;
		}

		public LiveEnum getLiveEnum() {
			return liveEnum;
		}

		@XmlElement
		public void setLiveEnumProp(LiveEnum liveEnumProp) {
			this.liveEnumProp = liveEnumProp;
		}

		public LiveEnum getLiveEnumProp() {
			return liveEnumProp;
		}

		public void setDeadLink(LiveEnum deadLink) {
			this.deadLink = deadLink;
		}

		public LiveEnum getDeadLink() {
			return deadLink;
		}

		// Live marshal and unmarshal methods
		public void afterUnmarshal(Unmarshaller a, Object b) {
		}

		public void beforeUnmarshal(Unmarshaller a, Object b) {
		}

		public void afterMarshal(Marshaller a, Object b) {
		}

		public void beforeMarshal(Marshaller a, Object b) {
		}
	}

	/**
	 * Using default XmlAccessType (PUBLIC_MEMBER), verify that the properties are identified.
	 */
	@XmlType
	public static class PublicMemberObject {
		private LiveEnum liveEnum;

		public void setLiveEnum(LiveEnum liveEnum) {
			this.liveEnum = liveEnum;
		}

		public LiveEnum getLiveEnum() {
			return liveEnum;
		}
	}

	/**
	 * Verify that the field is picked up.
	 */
	@XmlAccessorType(XmlAccessType.FIELD)
	@XmlType
	public static class FieldObject {
		private LiveEnum liveEnum;

		public void setLiveEnum(LiveEnum liveEnum) {
			this.liveEnum = liveEnum;
		}

		public LiveEnum getLiveEnum() {
			return liveEnum;
		}
	}

	/**
	 * A class whose setter/getter would be live, but the constructor is not live.
	 */
	@XmlType
	public static class DeadPublicMemberObject {
		private LiveEnum deadProperty;

		public void setDeadProperty(LiveEnum deadProperty) {
			this.deadProperty = deadProperty;
		}

		public LiveEnum getDeadProperty() {
			return deadProperty;
		}

		public static void liveMethod() { }
	}

	@XmlEnum
	public static enum LiveEnum {
		A;
	}

	/**
	 * A class that is live because it is referred to in AnnotatedObject.
	 */
	public static class UnnannotatedLiveClass {
		@XmlElement
		private LiveEnum liveEnum;

		public void setLiveEnum(LiveEnum liveEnum) {
			this.liveEnum = liveEnum;
		}

		public LiveEnum getLiveEnum() {
			return liveEnum;
		}
	}

	public static void main(String[] args) {
		DeadPublicMemberObject.liveMethod();
	}
}
