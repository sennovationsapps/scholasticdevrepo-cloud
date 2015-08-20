package controllers;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import com.avaje.ebean.Ebean;
import com.avaje.ebean.SqlQuery;
import com.avaje.ebean.SqlRow;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.JsonNode;
import models.*;
import models.Donation;
import models.Event;
import models.Pfp;
import models.Pfp.PfpType;
import models.Shift;
import models.Volunteer;
import models.Volunteers;
import models.security.SecurityRole;

import org.apache.commons.lang3.StringUtils;

import play.Logger;
import play.api.mvc.Rendering;
import play.data.Form;
import play.libs.F.Option;
import play.mvc.Controller;
import play.mvc.Result;
import au.com.bytecode.opencsv.CSVWriter;
import base.utils.DateUtils;
import base.utils.DebugUtils;
import be.objectify.deadbolt.java.actions.Group;
import be.objectify.deadbolt.java.actions.Restrict;
import be.objectify.deadbolt.java.actions.SubjectPresent;
import play.libs.Json;


/**
 * The Class ReportMgmt.
 */
public class ReportMgmt extends Controller {

	/**
	 * Donations report.
	 * 
	 * @return the result
	 * @throws IOException
	 *             Signals that an I/O exception has occurred.
	 */
	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
		@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
		@Group(SecurityRole.EVENT_ASSIST) })
	@SubjectPresent(content = "/login")
	public static Result adminDonationsReport(Event event) throws IOException {
		Map<String, String> requestData = Form.form().bindFromRequest().data();
		if(StringUtils.isEmpty(requestData.get("paymentType"))) {
			requestData.remove("paymentType");
		}
		if(StringUtils.isEmpty(requestData.get("status"))) {
			requestData.remove("status");
		}
		if(StringUtils.isEmpty(requestData.get("fromDate")) || !DateUtils.parseDate(requestData.get("fromDate")).isDefined()) {
			requestData.remove("fromDate");
		}
		if(StringUtils.isEmpty(requestData.get("toDate")) || !DateUtils.parseDate(requestData.get("toDate")).isDefined()) {
			requestData.remove("toDate");
		}
		List<Donation> donations = Donation.findAllByEventIdAndOptions(event.id, requestData);
		Logger.debug("Donations size {}", donations.size());
		final File file = new File("yourfile.csv");
		final BufferedWriter out = new BufferedWriter(new FileWriter(file));
		final CSVWriter writer = new CSVWriter(out, ',');
		List<String[]> data = null;
		DebugUtils.callout();
		System.out.println("Total by PFP - " + requestData.get("totalByPfp"));
		System.out.println((StringUtils.isNotEmpty(requestData.get("totalByPfp")) && Boolean.getBoolean(requestData.get("totalByPfp"))));
		System.out.println(Boolean.parseBoolean(requestData.get("totalByPfp")));
		DebugUtils.callout();
		if(StringUtils.isNotEmpty(requestData.get("totalByPfp")) && Boolean.parseBoolean(requestData.get("totalByPfp"))) {
			data = donatioTotalToStringArray(donations);
		} else {
			data = donationToStringArray(donations);
		}
		writer.writeAll(data);
		writer.close();
		response().setHeader("Content-Disposition",
				"attachment; filename=\"DonationsReport.csv\"");
		response().setContentType("text/csv");
		return ok(file).as("text/csv");
	}
	
	/**
	 * Donations report.
	 * 
	 * @return the result
	 * @throws IOException
	 *             Signals that an I/O exception has occurred.
	 */
	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
		@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
		@Group(SecurityRole.EVENT_ASSIST) })
	@SubjectPresent(content = "/login")
	public static Result adminVolunteersReport(Event event) throws IOException {
		Map<String, String> requestData = Form.form().bindFromRequest().data();
		if(StringUtils.isEmpty(requestData.get("fromDate")) || !DateUtils.parseDate(requestData.get("fromDate")).isDefined()) {
			requestData.remove("fromDate");
		}
		if(StringUtils.isEmpty(requestData.get("toDate")) || !DateUtils.parseDate(requestData.get("toDate")).isDefined()) {
			requestData.remove("toDate");
		}
		Volunteers volunteers = Volunteers.findAllByEventIdAndOptions(event.id, requestData);
		List<String[]> data = null;
		if(volunteers != null) {
			List<Shift> shifts = volunteers.shifts;
			Logger.debug("Shift size {}", shifts.size());
			data = shiftToStringArray(shifts);
		} else {
			data = new ArrayList<String[]>();
		}
		final File file = new File("yourfile.csv");
		final BufferedWriter out = new BufferedWriter(new FileWriter(file));
		final CSVWriter writer = new CSVWriter(out, ',');
		writer.writeAll(data);
		writer.close();
		response().setHeader("Content-Disposition",
				"attachment; filename=\"VolunteersReport.csv\"");
		response().setContentType("text/csv");
		return ok(file).as("text/csv");
	}
	
	/**
	 * Donations report.
	 * 
	 * @return the result
	 * @throws IOException
	 *             Signals that an I/O exception has occurred.
	 */
	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
		@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
		@Group(SecurityRole.EVENT_ASSIST) })
	@SubjectPresent(content = "/login")
	public static Result adminPfpsReport(Event event) throws IOException {
		Map<String, String> requestData = Form.form().bindFromRequest().data();
		if(StringUtils.isEmpty(requestData.get("pfpType"))) {
			requestData.remove("pfpType");
		}
		if(StringUtils.isEmpty(requestData.get("fromDate")) || !DateUtils.parseDate(requestData.get("fromDate")).isDefined()) {
			requestData.remove("fromDate");
		}
		if(StringUtils.isEmpty(requestData.get("toDate")) || !DateUtils.parseDate(requestData.get("toDate")).isDefined()) {
			requestData.remove("toDate");
		}
		List<Pfp> pfps = Pfp.findAllByEventIdAndOptions(event.id, requestData);
		Logger.debug("Pfp size {}", pfps.size());
		final File file = new File("yourfile.csv");
		final BufferedWriter out = new BufferedWriter(new FileWriter(file));
		final CSVWriter writer = new CSVWriter(out, ',');
		final List<String[]> data = pfpToStringArray(pfps);
		writer.writeAll(data);
		writer.close();
		response().setHeader("Content-Disposition",
				"attachment; filename=\"PfpsReport.csv\"");
		response().setContentType("text/csv");
		return ok(file).as("text/csv");
	}
	
//	/**
//	 * Donations report.
//	 * 
//	 * @return the result
//	 * @throws IOException
//	 *             Signals that an I/O exception has occurred.
//	 */
//	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
//		@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
//		@Group(SecurityRole.EVENT_ASSIST) })
//	@SubjectPresent(content = "/login")
//	public static Result allDonationsReport(Event event) throws IOException {
//		String paymentType = request().getQueryString("paymentType");
//		// DynamicForm reportForm = form().bindFromRequest();
//		// String reportType = reportForm.get("reportType");
//		// String id = reportForm.get("id");
//		List<Donation> donations = Donation.findAllByEventIdAndPaymentType(event.id, paymentType);
//		Logger.debug("Donations size {}", donations.size());
//		final File file = new File("yourfile.csv");
//		final BufferedWriter out = new BufferedWriter(new FileWriter(file));
//		final CSVWriter writer = new CSVWriter(out, ',');
//		final List<String[]> data = toStringArray(donations);
//		writer.writeAll(data);
//		writer.close();
//		response().setHeader("Content-Disposition",
//				"attachment; filename=\"allDonationsReport.csv\"");
//		response().setContentType("text/csv");
//		return ok(file).as("text/csv");
//	}
//	
//	/**
//	 * Donations report.
//	 * 
//	 * @return the result
//	 * @throws IOException
//	 *             Signals that an I/O exception has occurred.
//	 */
//	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
//		@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
//		@Group(SecurityRole.EVENT_ASSIST) })
//	@SubjectPresent(content = "/login")
//	public static Result clearedDonationsReport(Event event) throws IOException {
//		String paymentType = request().getQueryString("paymentType");
//		// DynamicForm reportForm = form().bindFromRequest();
//		// String reportType = reportForm.get("reportType");
//		// String id = reportForm.get("id");
//		List<Donation> donations = Donation.findAllByEventIdAndClearedAndPaymentType(event.id, paymentType);
//		Logger.debug("Donations size {}", donations.size());
//		final File file = new File("yourfile.csv");
//		final BufferedWriter out = new BufferedWriter(new FileWriter(file));
//		final CSVWriter writer = new CSVWriter(out, ',');
//		final List<String[]> data = toStringArray(donations);
//		writer.writeAll(data);
//		writer.close();
//		response().setHeader("Content-Disposition",
//				"attachment; filename=\"clearedDonationsReport.csv\"");
//		response().setContentType("text/csv");
//		return ok(file).as("text/csv");
//	}
//	
//	/**
//	 * Donations report.
//	 * 
//	 * @return the result
//	 * @throws IOException
//	 *             Signals that an I/O exception has occurred.
//	 */
//	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
//		@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
//		@Group(SecurityRole.EVENT_ASSIST) })
//	@SubjectPresent(content = "/login")
//	public static Result lastWeekReport(Event event) throws IOException {
//		String paymentType = request().getQueryString("paymentType");
//		// DynamicForm reportForm = form().bindFromRequest();
//		// String reportType = reportForm.get("reportType");
//		// String id = reportForm.get("id");
//		Date to = new Date();
//		Calendar cal = Calendar.getInstance();
//		cal.add(Calendar.DATE, -7);
//		Date from = cal.getTime();
//		List<Donation> donations = Donation.findAllByEventIdAndDateRangeAndPaymentType(event.id, from, to, paymentType);
//		Logger.debug("Donations size {}", donations.size());
//		final File file = new File("yourfile.csv");
//		final BufferedWriter out = new BufferedWriter(new FileWriter(file));
//		final CSVWriter writer = new CSVWriter(out, ',');
//		final List<String[]> data = toStringArray(donations);
//		writer.writeAll(data);
//		writer.close();
//		response().setHeader("Content-Disposition",
//				"attachment; filename=\"lastWeeksDonationsReport.csv\"");
//		response().setContentType("text/csv");
//		return ok(file).as("text/csv");
//	}

	/**
	 * To string array.
	 * 
	 * @param donations
	 *            the donations
	 * @return the list
	 */
	private static List<String[]> donationToStringArray(List<Donation> donations) {
		final List<String[]> records = new ArrayList<String[]>();
		// add header record
		records.add(new String[] { "Event Name", " PFP Name", "Team Name", "Donor First Name", "Donor Last Name", "Donation Zip", "Donor Email", "Donor Phone", "Donation Type", "Date Created", "Date Paid", "Payment Type", "Status",
				"Amount", "Transaction Number" });
		for(Donation donation: donations) {
			String datePaid = "";
			String dateCreated = "";
			String teamName = "";
			
			if(donation.datePaid != null) {
				datePaid = new SimpleDateFormat("MM/dd/yyyy").format(donation.datePaid);
			}
			if(donation.dateCreated != null) {
				dateCreated = new SimpleDateFormat("MM/dd/yyyy").format(donation.dateCreated);
			}
			if(donation.pfp.pfpType == PfpType.GENERAL) {
				teamName = PfpType.GENERAL.value;
			} else if(donation.pfp.pfpType == PfpType.SPONSOR) {
				teamName = PfpType.SPONSOR.value;
			} else {
				if(donation.pfp.team == null) {
					teamName = "No Team Selected";
				} else {
					teamName = donation.pfp.team.name;
				}
			}
			if (donation.pfp == null) {
				records.add(new String[] { donation.event.name, "none",
						teamName, donation.firstName, donation.lastName, donation.zipCode + "", donation.email, donation.phone, donation.donationType.value, dateCreated, datePaid, donation.paymentType.value, donation.status.value, donation.amount + "", donation.transactionNumber });
			} else {
				records.add(new String[] { donation.event.name, donation.pfp.name, 
						teamName, donation.firstName, donation.lastName, donation.zipCode + "", donation.email, donation.phone, donation.donationType.value, dateCreated, datePaid, donation.paymentType.value, donation.status.value, donation.amount + "", donation.transactionNumber });
			}
		}
		return records;
	}
	
	/**
	 * To string array.
	 * 
	 * @param donations
	 *            the donations
	 * @return the list
	 */
	private static List<String[]> donatioTotalToStringArray(List<Donation> donations) {
		final List<String[]> records = new ArrayList<String[]>();
		// add header record
		records.add(new String[] { "Event Name", " PFP Name", "Team Name", "Donor First Name", "Donor Last Name", "Donation Zip", "Donor Email", "Donor Phone", "Donation Type", "Date Created", "Date Paid", "Payment Type", "Status",
				"Transaction Number", "Donations Total", "Donations Amount" });
		Map<Long, Donation> pfpDonations = new HashMap<Long, Donation>();
		for(Donation donation: donations) {
			if(pfpDonations.containsKey(donation.pfp.id)) {
				Donation pfpDonation = pfpDonations.get(donation.pfp.id);
				pfpDonation.donationTotal = pfpDonation.donationTotal + donation.amount;
				pfpDonation.donationCount = pfpDonation.donationCount + 1;
				pfpDonations.put(donation.pfp.id, pfpDonation);
			} else {
				Donation pfpDonation = donation;
				pfpDonation.donationTotal = pfpDonation.amount;
				pfpDonation.donationCount = 1;
				pfpDonations.put(donation.pfp.id, pfpDonation);
			}
		}
		
		for(Long key: pfpDonations.keySet()) {
			String datePaid = "";
			String dateCreated = "";
			String teamName = "";
			
			Donation donation = pfpDonations.get(key);
			if(donation.datePaid != null) {
				datePaid = new SimpleDateFormat("MM/dd/yyyy").format(donation.datePaid);
			}
			if(donation.dateCreated != null) {
				dateCreated = new SimpleDateFormat("MM/dd/yyyy").format(donation.dateCreated);
			}
			if(donation.pfp.pfpType == PfpType.GENERAL) {
				teamName = PfpType.GENERAL.value;
			} else if(donation.pfp.pfpType == PfpType.SPONSOR) {
				teamName = PfpType.SPONSOR.value;
			} else {
				if(donation.pfp.team == null) {
					teamName = "No Team Selected";
				} else {
					teamName = donation.pfp.team.name;
				}
			}
			if (donation.pfp == null) {
				records.add(new String[] { donation.event.name, "none",
						teamName, donation.firstName, donation.lastName, donation.zipCode + "", donation.email, donation.phone, donation.donationType.value, dateCreated, datePaid, donation.paymentType.value, donation.status.value, donation.transactionNumber, donation.donationTotal + "", donation.donationCount + "" });
			} else {
				records.add(new String[] { donation.event.name, donation.pfp.name, 
						teamName, donation.firstName, donation.lastName, donation.zipCode + "", donation.email, donation.phone, donation.donationType.value, dateCreated, datePaid, donation.paymentType.value, donation.status.value, donation.transactionNumber, donation.donationTotal + "", donation.donationCount + "" });
			}
		}
		return records;
	}

	/**
	 * To string array.
	 * 
	 * @param donations
	 *            the donations
	 * @return the list
	 */
	private static List<String[]> shiftToStringArray(List<Shift> shifts) {
		final List<String[]> records = new ArrayList<String[]>();
		// add header record
		List<Shift> sortedShifts = Shift.getSortedShifts(shifts);
		records.add(new String[] { "Shift Name", "Shift Date", "Shift Start Time", "Shift End Time", "Volunteer Count", "Name", " Mobile", "Phone", "Email", "Note" });
		for(Shift shift: sortedShifts) {
			String shiftDate = "";
			String shiftStartTime = "";
			String shiftEndTime = "";
			
			if(shift.date != null) {
				shiftDate = new SimpleDateFormat("MM/dd/yyyy").format(shift.date);
			}
			if(shift.startTime != null) {
				shiftStartTime = new SimpleDateFormat("h:mm a").format(shift.date);
			}
			if(shift.endTime != null) {
				shiftEndTime = new SimpleDateFormat("h:mm a").format(shift.date);
			}
			for(Volunteer volunteer: shift.volunteerList) {
				records.add(new String[] { shiftDate, shiftStartTime, shiftEndTime, shift.name, shift.volunteerCount + "", volunteer.firstName + " " + volunteer.lastName, volunteer.mobile,
						volunteer.phone, volunteer.email, volunteer.note });
			}
			for(int count = shift.volunteerList.size() + 1; count <= shift.volunteerCount; count++) {
				records.add(new String[] { shiftDate, shiftStartTime, shiftEndTime, shift.name, shift.volunteerCount + "", "Available", "",
								"", "", "" });
			}
		}
		return records;
	}
	
	/**
	 * To string array.
	 * 
	 * @param donations
	 *            the donations
	 * @return the list
	 */
	private static List<String[]> pfpToStringArray(List<Pfp> pfps) {
		final List<String[]> records = new ArrayList<String[]>();
		// add header record
		records.add(new String[] { "Name", "Date Created", "Goal", "Emergency Contact", "Emergency Contact Phone", "Pfp Type", "Team Name", "Event Name", "Admin Name", "Admin Email", "Admin Phone",
				"Amount", "Transaction Number" });
		for(Pfp pfp: pfps) {
			String dateCreated = "";
			String teamName = "";
			
			if(pfp.dateCreated != null) {
				dateCreated = new SimpleDateFormat("MM/dd/yyyy").format(pfp.dateCreated);
			}
			if(pfp.pfpType == PfpType.GENERAL) {
				teamName = PfpType.GENERAL.value;
			} else if(pfp.pfpType == PfpType.SPONSOR) {
				teamName = PfpType.SPONSOR.value;
			} else {
				if(pfp.team == null) {
					teamName = "No Team Selected";
				} else {
					teamName = pfp.team.name;
				}
			}
			records.add(new String[] { pfp.name, dateCreated + "", pfp.goal + "", pfp.emergencyContact, pfp.emergencyContactPhone, pfp.pfpType.value,
							teamName, pfp.event.name, pfp.userAdmin.firstName + " " + pfp.userAdmin.lastName, pfp.userAdmin.email, pfp.userAdmin.phone });
		}
		return records;
	}

/**
	 * Participant  report (added Suvadeep Datta).
	 *
	 * @return the result
	 * @throws IOException
	 *             Signals that an I/O exception has occurred.
	 */
	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
			@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
			@Group(SecurityRole.EVENT_ASSIST) })
	@SubjectPresent(content = "/login")
	public static Result participantReport(String event) throws IOException {
		Event eventy=Event.findBySlug(event);
		String sql =
		"select name,(select distinct name from team where id=team_id) team," +
				"emergency_contact ,emergency_contact_phone,goal,total " +
				"from pfp where pfp_type=1 and event_id=:id";
		SqlQuery bug = Ebean.createSqlQuery(sql)
				       .setParameter("id", eventy.id);
		List<SqlRow> list = bug.findList();

		//List<Pfp> pfp = Pfp.findAll(event);// need to remove from pfp
		JsonNode myJsonNode = Json.toJson(list);


		//System.out.println("asdadasdasdsadsadasdasddsadas"+event);
		return ok(myJsonNode);

	}
	/**
	 * Donation  report (added Suvadeep Datta).
	 *
	 * @return the result
	 * @throws IOException
	 *             Signals that an I/O exception has occurred.
	 */
	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
			@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
			@Group(SecurityRole.EVENT_ASSIST) })
	@SubjectPresent(content = "/login")
	public static Result donationReport(String event) throws IOException {
		Event eventy=Event.findBySlug(event);
		String sql =
		"select p.team,p.name participant,d.donor_name,d.amount,CAST(d.date_paid AS char) date_paid, "+
				"case d.payment_type when 1 then 'credit' when 2 then 'check' when 3 then 'cash' end as payment_type "+
				"from donation d join"+
				"(select id,name,title,(select distinct name from team where id=pfp.team_id) " +
				" team,event_id from pfp where pfp.pfp_type=1 ) p "+
				"where d.status=2 "+
				"and d.pfp_id=p.id "+
				"and p.event_id=d.event_id "+
				"and p.event_id=:id "+
				"and d.donation_type=1";
		SqlQuery bug = Ebean.createSqlQuery(sql)
				.setParameter("id", eventy.id);
		List<SqlRow> list = bug.findList();
		JsonNode myJsonNode = Json.toJson(list);
		return ok(myJsonNode);
	}
	/**
	 * To string array.
	 *
	 * @param volunteers (added Suvadeep Datta)
	 *            the donations
	 * @return the list
	 */

	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
			@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
			@Group(SecurityRole.EVENT_ASSIST) })
	@SubjectPresent(content = "/login")
	public static Result volunteersReport(String event) throws IOException {
		Event eventy=Event.findBySlug(event);

		String sql =
				"select v.first_name,v.last_name, v.email,v.mobile,v.phone,"+
				"a.name as shift_name,CAST(a.start_time AS char),CAST(a.end_time AS char) from "+
				"(select id,date,name,start_time,end_time from shift where " +
				"volunteers_id=(select id from volunteers where eventid=:id)) a join volunteer v on v.shift_id=a.id ";

		SqlQuery bug = Ebean.createSqlQuery(sql)
				.setParameter("id", eventy.id);
		List<SqlRow> list = bug.findList();
		//List<Volunteers> allvolunteers = Volunteers.findAllVolunteer(event);
		JsonNode myJsonNode = Json.toJson(list);
		return ok(myJsonNode);
	}
	/**
	 * To string array.
	 *
	 * @param sponser (added Suvadeep Datta)
	 *            the donations
	 * @return the list
	 */

	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
			@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
			@Group(SecurityRole.EVENT_ASSIST) })
	@SubjectPresent(content = "/login")

	public static Result sponsorReport(String event) throws IOException {
		Event eventy=Event.findBySlug(event);
		String sql =
		"select donor_name sponsor, sum(amount) from donation where donation_type=3 and event_id=:id "+
		"group by id,donor_name order by sum(amount)desc";
		SqlQuery bug = Ebean.createSqlQuery(sql)
				.setParameter("id", eventy.id);
		List<SqlRow> list = bug.findList();
		JsonNode myJsonNode = Json.toJson(list);
		return ok(myJsonNode);


	}


	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
			@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
			@Group(SecurityRole.EVENT_ASSIST) })
	@SubjectPresent(content = "/login")
	public static Result donorReport(String event) throws IOException {
		Event eventy=Event.findBySlug(event);
		String sql =
				"select donor_name,first_name,last_name,sum(amount) amount from donation " +
						"where event_id=:id and donation_type=1 group by id,donor_name order by sum(amount)desc";
		SqlQuery bug = Ebean.createSqlQuery(sql)
				.setParameter("id", eventy.id);
		List<SqlRow> list = bug.findList();
		JsonNode myJsonNode = Json.toJson(list);
		return ok(myJsonNode);

	}

	@Restrict({ @Group(SecurityRole.ROOT_ADMIN),
			@Group(SecurityRole.SYS_ADMIN), @Group(SecurityRole.EVENT_ADMIN),
			@Group(SecurityRole.EVENT_ASSIST) })
	@SubjectPresent(content = "/login")
	public static Result teamReport(String event) throws IOException {
		Event eventy=Event.findBySlug(event);
		String sql =
		"select (select distinct name from team where id=team_id) team ,name " +
				" participant_name,total from pfp " +
				"where pfp_type=1 and event_id=:id";
		SqlQuery bug = Ebean.createSqlQuery(sql)
				.setParameter("id", eventy.id);
		List<SqlRow> list = bug.findList();
		JsonNode myJsonNode = Json.toJson(list);
		return ok(myJsonNode);


	}
	
}